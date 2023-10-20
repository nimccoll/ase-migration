#===============================================================================
# Microsoft FastTrack for Azure
# Backup and Restore ASE v1 / v2 web application to ASE v3 web application
#===============================================================================
# Copyright © Microsoft Corporation.  All rights reserved.
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
# OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
#===============================================================================
param(
    [Parameter(Mandatory)]$resourceGroupName,
    [Parameter(Mandatory)]$webappname,
    [Parameter(Mandatory)]$targetResourceGroupName,
    [Parameter(Mandatory)]$targetWebappName
)

# Retrieve backup configuration
Write-Host "Retrieving backup configuration for" $webappname"..."
$backupConfig = Get-AzWebAppBackupConfiguration -ResourceGroupName $resourceGroupName -Name $webappname

# Create new backup
Write-Host "Creating backup of" $webappname"..."
$backup = New-AzWebAppBackup -ResourceGroupName $resourceGroupName -Name $webappname -StorageAccountUrl $backupConfig.StorageAccountUrl

# Check status of the backup that are complete or currently executing.
do
{
    Start-Sleep -Seconds 60
    $backup = Get-AzWebAppBackup -ResourceGroupName $resourceGroupName -Name $webappname -BackupId $backup.BackupId
} until ($backup.BackupStatus -ne "InProgress")

if ($backup.BackupStatus -eq "Succeeded")
{
    Write-Host "Backup of primary site succeeded!" -ForegroundColor Green
    
    # Restore backup to secondary site
    Write-Host "Restoring backup to secondary site" $targetWebappName"..."

    Restore-AzWebAppBackup -ResourceGroupName $targetResourceGroupName -Name $targetWebappName -StorageAccountUrl $backupConfig.StorageAccountUrl -BlobName $backup.BlobName -Overwrite
    Start-Sleep -Seconds 900

    Write-Host "Restore of backup to secondary site succeeded!" -ForegroundColor Green
}
