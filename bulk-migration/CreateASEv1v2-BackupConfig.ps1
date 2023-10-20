#===============================================================================
# Microsoft FastTrack for Azure
# Create backup configuration for ASE v1 / v2 web application
#===============================================================================
# Copyright © Microsoft Corporation.  All rights reserved.
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
# OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
#===============================================================================
param(
    [Parameter(Mandatory)]$webappResourceGroupName,
    [Parameter(Mandatory)]$webappname,
    [Parameter(Mandatory)]$storageAccountResourceGroupName,
    [Parameter(Mandatory)]$storageAccountName,
    [Parameter(Mandatory)]$containerName
)

$storageAccount = Get-AzStorageAccount -ResourceGroupName $storageAccountResourceGroupName -Name $storageAccountName
$sasUrl = New-AzStorageContainerSASToken -Name $containerName -Permission rwdl -Context $storageAccount.Context -ExpiryTime (Get-Date).AddYears(1) -FullUri

Edit-AzWebAppBackupConfiguration -ResourceGroupName $webappResourceGroupName -Name $webappname -StorageAccountUrl $sasUrl -FrequencyInterval 1 -FrequencyUnit Day -KeepAtLeastOneBackup -StartTime (Get-Date).AddDays(365) -RetentionPeriodInDays 60