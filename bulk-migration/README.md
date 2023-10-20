# bulk-migration
Contains PowerShell scripts to assist in migrating all applications on an existing ASE v1 / v2 to a new ASE v3 using either backup and restore or clone

## ListASEv1v2Apps.ps1
This script will retrieve all of the applications for the specified ASE v1 / v2 and write the information to an output file that will drive the migration.

### Inputs
- aseResourceGroupName - The resource group of the ASE v1 / v2
- aseName - The name of the ASE v1 / v2
### Output
- A folder named output will be created containing a .csv file prefixed with the ASE v1 / v2 name. The .csv file contains the following columns:

| Column Name | Description |
|-------------|-------------|
| WebAppName  | Name of the source web application |
| ResourceGroup | Name of the source resource group |
| Action      | backuprestore or clone |
| targetWebAppName | Name of the destination web application |
| targetResourceGroup | Name of the destination resource group |
| targetAppServicePlan | Name of the destination App Service Plan |
| targetAzureRegion | Destination Azure region |
| storageAccountResourceGroup | Resource group name of the resource group containing the storage account that will be used for creating backups |
| storageAccountName | Name of the storage account that will be used for creating backups |
| containerName | Name of the storage container where the backups will be created |

## Preparing the .csv file for migration
Once the .csv file has been created you must populate the following columns before running the MigrateASEv1v2Apps.ps1 script. Note that the **WebAppName**, **ResourceGroup**, and **Action** columns are populated by the ListASEv1v2Apps.ps1 script. The **Action** column is set to clone for Windows App Services and backuprestore for Linux App Services.
- **targetWebAppName** - If the Action is set to backuprestore, an empty web application in the destination App Service Plan must be created. If the Action is set to clone, do **not** create a web application with this name as the clone process will create it.
- **targetResourceGroup**
- **targetAppServicePlan** - Make sure the App Service Plan is created prior to running the migration script.
- **targetAzureRegion**
- **storageAccountResourceGroup** - Must only be provided if the Action is set to backuprestore.
- **storageAccountName** - Must only be provided if the Action is set to backuprestore. The storage account must be created prior to running the migration script.
- **containerName** - Must only be provided if the Action is set to backuprestore. The container must be created prior to running the migration script. 

## MigrateASEv1v2Apps.ps1
This script will read the .csv input file and migrate each source application to the destination application specified in the input file using either backup and restore or clone.

### Inputs
- aseName - The name of the ASE v1 / v2. This is used to reconstruct the name of the .csv in the output folder which is used to drive the processing in the migration script.

## Modifying the Action column in the .csv file
By default the Action value in the .csv file will be set to clone for Windows App Services and backuprestore for Linux App Services. You can change the value for Windows App Services to backuprestore if necessary and provide the additional parameters required. This may be necessary if your organization requires tags to be provided at resource creation time. The Azure PowerShell commands for cloning a web application do not provide an option to specify tags at this time.