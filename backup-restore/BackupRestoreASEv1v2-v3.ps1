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
Write-Output "Retrieving backup configuration..."
$backupConfig = Get-AzWebAppBackupConfiguration -ResourceGroupName $resourceGroupName -Name $webappname

# Create new backup
Write-Output "Creating backup of primary site..."
$backup = New-AzWebAppBackup -ResourceGroupName $resourceGroupName -Name $webappname -StorageAccountUrl $backupConfig.StorageAccountUrl

# Check status of the backup that are complete or currently executing.
do
{
    Start-Sleep -Seconds 60
    $backup = Get-AzWebAppBackup -ResourceGroupName $resourceGroupName -Name $webappname -BackupId $backup.BackupId
} until ($backup.BackupStatus -ne "InProgress")

if ($backup.BackupStatus -eq "Succeeded")
{
    Write-Output "Backup of primary site succeeded!"
    
    # Restore backup to secondary site
    Write-Output "Restoring backup to secondary site..."

    Restore-AzWebAppBackup -ResourceGroupName $targetResourceGroupName -Name $targetWebappName -StorageAccountUrl $backupConfig.StorageAccountUrl -BlobName $backup.BlobName -Overwrite
    Start-Sleep -Seconds 900

    Write-Output "Restore of backup to secondary site succeeded!"
}
