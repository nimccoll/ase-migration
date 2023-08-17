#===============================================================================
# Microsoft FastTrack for Azure
# Clone Windows web application
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
    [Parameter(Mandatory)]$targetResourceGroupName,
    [Parameter(Mandatory)]$targetWebAppName,
    [Parameter(Mandatory)]$targetAppServicePlanName,
    [Parameter(Mandatory)]$targetAzureRegionName
)
Write-Output "Retrieving source web application..."
$srcapp = Get-AzWebApp -ResourceGroupName $webappResourceGroupName -Name $webappname
Write-Output "Cloning source web application to target web application..."
$destapp = New-AzWebApp -ResourceGroupName $targetResourceGroupName -Name $targetWebAppName -Location $targetAzureRegionName -AppServicePlan $targetAppServicePlanName -SourceWebApp $srcapp