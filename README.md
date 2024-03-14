# ase-migration
Contains helpful scripts and tools for migrating your ASE v1 / v2 to ASE v3

## backup-restore
This folder contains PowerShell scripts to assist in configuring custom backups for a web application in your ASE v1 / v2 and for backing up and restoring a web application in your ASE v1 / v2 to a web application in your ASE v3.

## clone
This folder contains PowerShell scripts to assist in cloning a Windows web application from an ASE v1 / v2 to an ASE v3.

## bulk-migration
This folder contains PowerShell scripts to assist in migrating all applications on an existing ASE v1 / v2 to a new ASE v3 using either backup and restore or clone. See the [README.md](bulk-migration/README.md) file in this directory for detailed instructions on how to bulk migrate an ASE v1 / v2 to an ASE v3.

### Pre-requisites
**backup-restore/CreateASEv1v2-BackupConfig.ps1**
- Make sure you have already created a storage account and blob container to store the backup files
- You will have to authenticate to Azure using Connect-AzAccount before running the script
- The user or service principal used to authenticate must have Contributor access on the storage account and web application

**backup-restore/BackupRestoreASEv1v2-v3.ps1**
- Make sure you have configured custom backups on the ASE v1 / v2 web application prior to running this script
- You will have to authenticate to Azure using Connect-AzAccount before running the script
- The user or service principal used to authenticate must have Contributor access on the storage account and web application
- Make sure the destination web application has been created in the ASE v3. The script does not create the web application.

**clone/CloneWebApp.ps1**
- You will have to authenticate to Azure using Connect-AzAccount before running the script
- The user or service principal used to authenticate must have Reader access on the source resource group and Contributor access on the target resource group
- Make sure the destination web application does **not** exist.

**bulk-migration/ListASEv1v2Apps.ps1**
- You will have to authenticate to Azure using Connect-AzAccount or az login before running the script
- The user or service principal used to authenticate must have Reader access on the ASE v1 / v2 resource group

**bulk-migration/MigrateASEv1v2Apps.ps1**
- You will have to authenticate to Azure using Connect-AzAccount or az login before running the script
- The user or service principal used to authenticate must have Contributor access on the source resource groups and target resource groups listed in the .csv input file

**side-by-side/sidebyside.sh**
- Access to a bash shell to run the script
- The user or service principal used to authenticate must have Contributor access on the ASE v2 resource group and the virtual network resouce group. See the [README](./side-by-side/README.md) for additional prerequisites.

**side-by-side/finalizesidebyside.sh**
- Access to a bash shell to run the script
- The user or service principal used to authenticate must have Contributor access on the ASE v2 resource group and the virtual network resouce group. See the [README](./side-by-side/README.md) for additional prerequisites.