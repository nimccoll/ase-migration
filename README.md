# ase-migration
Contains helpful scripts and tools for migrating your ASE v1 / v2 to ASE v3

## backup-restore
This folder contains PowerShell scripts to assist in configuring custom backups for a web application in your ASE v1 / v2 and for backing up and restoring a web application in your ASE v1 / v2 to a web application in your ASE v3.

### Pre-requisites
**CreateASEv1v2-BackupConfig.ps1**
- Make sure you have already created a storage account and blob container to store the backup files
- You will have to authenticate to Azure using Connect-AzAccount before running the script
- The user or service principal used to authenticate must have Contributor access on the storage account and web application

**BackupRestoreASEv1v2-v3.ps1**
- Make sure you have configured custom backups on the ASE v1 / v2 web application prior to running this script
- You will have to authenticate to Azure using Connect-AzAccount before running the script
- The user or service principal used to authenticate must have Contributor access on the storage account and web application
