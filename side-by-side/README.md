# side-by-side
Contains bash scripts to simplify executing the commands to perform a side-by-side migration of an ASE v2 to an ASE v3. Remember that side-by-side migration only supports migrating an ASE v2 to an ASE v3. Do **not** attempt to use these scripts to migrate an ASE v1 to an ASE v3.

## sidebyside.sh
This script will assist you in executing all of the commands to perform a side-by-side migration of an ASE v2 to an ASE v3 to the point where the migration is in the MigrationPendingDnsChange state. At this point, you can verify that your applications are functioning properly on the ASE v3 before finalizing the migration.

### Inputs
- **subscriptionID** - Your subscription ID
- **aseResourceGroupName** - The name of the resource group containing your ASE v2
- **aseName** - The name of your ASE v2
- **vnetResourceGroupName** - The name of the resource group containing the virtual network of your ASE v2
- **vnetName** - The name of the virtual network for your ASE v2
- **newSubnetName** - The name of the new subnet where your ASE v3 will be deployed

## finalizesidebyside.sh
This script will execute the final commands to commit the migration of your ASE v2 to ASE v3 and delete the old ASE v2.

### Inputs
- **subscriptionID** - Your subscription ID
- **aseResourceGroupName** - The name of the resource group containing your ASE v2
- **aseName** - The name of your ASE v2

## zoneredundancy.json
A sample JSON zoneredundancy input file configured for no zone redundancy.

## parameters.json
A sample JSON parameters input file configured for no zone redundancy and no custom domain suffix.

## Prerequisites
1. Make sure you have access to a bash shell where you can execute these scripts. They **cannot** be executed from PowerShell or a Windows Command shell.
1. Make sure you have the latest version of the Azure CLI installed.
1. Make sure you have Contributor access to the resource group containing your ASE v2 and the resource group containing your virtual network.
1. Review the documentation on using the side-by-side migration feature to migrate an ASE v2 to an ASE v3 found here to familiarize yourself with what the scripts are doing:
    - [Overview](https://learn.microsoft.com/en-us/azure/app-service/environment/side-by-side-migrate)
    - [Walkthrough](https://learn.microsoft.com/en-us/azure/app-service/environment/how-to-side-by-side-migrate)
1. Clone this repository or download and extract the ZIP archive
1. Open a bash shell and navigate to the folder containing the scripts. Execute a chmod u+x command on sidebyside.sh and finalizesidebyside.sh to make them executable.
1. Modify the zoneredundancy.json file to meet your requirements as documented [here](https://learn.microsoft.com/en-us/azure/app-service/environment/how-to-side-by-side-migrate#4-generate-ip-addresses-for-your-new-app-service-environment-v3).
1. Modify the parameters.json file to meet your requirements as documented [here](https://learn.microsoft.com/en-us/azure/app-service/environment/how-to-side-by-side-migrate#7-prepare-your-configurations).
1. Execute the sidebyside.sh script to begin the migration (./sidebyside.sh). When you get to the final step, remember that it will typically take between 3 and 4 hours for the migration to complete. The script provides you with a mechanism to periodically check the status until it completes.
10. Once sidebyside.sh has completed, you now have the opportunity to validate that your applications are running properly on your new ASE v3. You may take as long as you like to verify the functionality of your applications.
11. Once you are satisfied that your applications are functioning as expected, execute finalizesidebyside.sh (./finalizesidebyside.sh) to commit your migration. This will typically take 60 - 90 minutes to complete. The script provides you with a mechanism to periodically check the status until it completes.