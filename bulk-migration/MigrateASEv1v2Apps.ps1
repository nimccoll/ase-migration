#===============================================================================
# Microsoft FastTrack for Azure
# Migrate ASE v1 / v2 Applications to ASE v3 via Backup / Restore or Clone
#===============================================================================
# Copyright © Microsoft Corporation.  All rights reserved.
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
# OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
#===============================================================================
param(
    [Parameter(Mandatory)]$aseName
)

$scriptRoot = $PSScriptRoot
$fileName = $scriptRoot + "\output\" + $aseName + ".csv"
$webappsToMigrate = Import-Csv $fileName
$webappsToMigrate | ForEach-Object {
    if ($_.Action -eq "clone") {
        Write-Host "Creating new web application" $_.targetWebAppName "via clone from" $_.WebAppName
        $cloneScriptPath = $scriptRoot + "\CloneWebApp.ps1"
        & $cloneScriptPath $_.ResourceGroup $_.WebAppName $_.targetResourceGroup $_.targetWebAppName $_.targetAppServicePlan $_.targetAzureRegion
    }
    elseif ($_.Action -eq "backuprestore") {
        Write-Host "Creating new web application" $_.targetWebAppName "via backup and restore"
        Write-Host "Configuring custom backups for" $_.WebAppName"..."
        $configBackupScriptPath = $scriptRoot + "\CreateASEv1v2-BackupConfig.ps1"
        & $configBackupScriptPath $_.ResourceGroup $_.WebAppName $_.storageAccountResourceGroup $_.storageAccountName $_.containerName
        Write-Host "Backing up and restoring..."
        $backupRestoreScriptPath = $scriptRoot + "\BackupRestoreASEv1v2-v3.ps1"
        & $backupRestoreScriptPath $_.ResourceGroup $_.WebAppName $_.targetResourceGroup $_.targetWebAppName
    }
}