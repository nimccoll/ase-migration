#!/bin/bash
#===============================================================================
# Microsoft FastTrack for Azure
# Finalize an ASE v2 Migration to ASE v3 via the Side-By-Side Migration Tool
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

# Login to Azure and set the subscription context
az login
az account set --subscription $subscriptionId

clear

# Get the identifier of the ASE being migrated
ASE_ID=$(az appservice ase show --name $aseName --resource-group $aseResourceGroupName --query id --output tsv)

# Finalize the ASE v2 to ASE v3 migration
read -p "Finalizing ASE v2 to ASE v3 migration. Press any key to continue " -n 1
az rest --method post --uri "${ASE_ID}/NoDowntimeMigrate?phase=DnsChange&api-version=2022-03-01"

migrateResults=$(az rest --method get --uri "${ASE_ID}?api-version=2022-03-01" --query properties.subStatus --output tsv)
until [ "$migrateResults" = "MigrationCompleted" ]
do
    read -p "Finalizing migration in progress. This will take between 60 and 90 minutes to complete. Press any key to check status " -n 1
    migrateResults=$(az rest --method get --uri "${ASE_ID}?api-version=2022-03-01" --query properties.subStatus --output tsv)
    echo "Current status: $migrateResults"
done
echo
echo "Your ASE v2 to ASE v3 migration is complete."