#!/bin/bash
#===============================================================================
# Microsoft FastTrack for Azure
# Migrate an ASE v2 to ASE v3 via the Side-By-Side Migration Tool
#===============================================================================
# Copyright © Microsoft Corporation.  All rights reserved.
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
# OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
#===============================================================================

read -p "subscriptionId: " subscriptionId
read -p "aseResourceGroupName: " aseResourceGroupName
read -p "aseName: " aseName
read -p "vnetResourceGroupName: " vnetResourceGroupName
read -p "vnetName: " vnetName
read -p "newSubnetName: " newSubnetName

# Login to Azure and set the subscription context
az login
az account set --subscription $subscriptionId

clear

# Get the identifier of the ASE being migrated
ASE_ID=$(az appservice ase show --name $aseName --resource-group $aseResourceGroupName --query id --output tsv)

read -p "Validating ASE v2 migration to ASE v3 using side-by-side migration. Press any key to continue " -n 1

# Validate that the ASE v2 is ready for migration
validateResults=$(az rest --method post --uri "${ASE_ID}/NoDowntimeMigrate?phase=Validation&api-version=2022-03-01" --query status --output tsv)

if [ "$validateResults" = "Success" ]; then
    echo "Validation Succeeded"
    echo
    echo "Preparing to create new outbound IP addresses for your ASE v3. Make sure you have created your zoneredundancy.json file in the current folder. Enter 1) to Continue or 2) to Cancel"
    select yn in "Continue" "Cancel"
    do
        case $yn in
            Continue )
                # Create new outbound IP addresses for the ASE v3
                echo "Creating IP addresses..."
                az rest --method post --uri "${ASE_ID}/NoDowntimeMigrate?phase=PreMigration&api-version=2022-03-01" --body @zoneredundancy.json
                ipResults=$(az rest --method get --uri "${ASE_ID}?api-version=2022-03-01" --query properties.status --output tsv)
                until [ "$ipResults" = "Ready" ]
                do
                    read -p "IP address creation in progress. Press any key to check status " -n 1
                    ipResults=$(az rest --method get --uri "${ASE_ID}?api-version=2022-03-01" --query properties.status --output tsv)
                    echo "Current status: $ipResults"
                done
                echo
                echo "IP addresses created successfully"
                echo
                echo "Here are the new outbound IP addresses for your ASE v3. Please update any network dependencies you may have, such as firewall rules, with these IP addresses before continuing."
                az rest --method get --uri "${ASE_ID}/configurations/networking?api-version=2022-03-01" --query properties.windowsOutboundIpAddresses --output tsv
                read -p "Once you have updated your network dependencies, press any key to continue " -n 1
                echo
                # List any locks on the virtual network where the ASE v3 will be deployed
                echo "Listing locks on the virtual network. If any locks are listed, please remove them before proceeding."
                az lock list --resource-group $vnetResourceGroupName --resource $vnetName --resource-type Microsoft.Network/virtualNetworks
                echo
                read -p "Ready to delegate new subnet to Microsoft.Web/hostingEnvironments. Press any key to continue " -n 1
                az network vnet subnet update --resource-group $vnetResourceGroupName --name $newSubnetName --vnet-name $vnetName --delegations Microsoft.Web/hostingEnvironments
                echo
                # Start the side-by-side migration
                read -p "Ready to start side-by-side migration. Make sure you have created your parameters.json file in the current folder. Press any key to continue " -n 1
                az rest --method post --uri "${ASE_ID}/NoDowntimeMigrate?phase=HybridDeployment&api-version=2022-03-01" --body @parameters.json
                migrateResults=$(az rest --method get --uri "${ASE_ID}?api-version=2022-03-01" --query properties.subStatus --output tsv)
                until [ "$migrateResults" = "MigrationPendingDnsChange" ]
                do
                    read -p "Side-by-side migration in progress. This will take between 3 and 6 hours to complete. Press any key to check status " -n 1
                    migrateResults=$(az rest --method get --uri "${ASE_ID}?api-version=2022-03-01" --query properties.subStatus --output tsv)
                    echo "Current status: $migrateResults"
                done
                echo
                echo "Side-by-side migration has completed and your new ASE v3 resources have been created. Please test and validate your applications. When you are satisified with the results of the migration, run the finalizesidebyside.sh script to commit the migration. If you need to revert the migration, contact support."                
                break;;
            Cancel )
                echo "User cancelled migration"
                break;;
        esac
    done
else
    echo "Validation Failed with the following status $validateResults"
fi