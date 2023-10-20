#===============================================================================
# Microsoft FastTrack for Azure
# List ASE v1 / v2 Applications for Migration to ASE v3
#===============================================================================
# Copyright © Microsoft Corporation.  All rights reserved.
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
# OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
#===============================================================================
param(
    [Parameter(Mandatory)]$aseResourceGroupName,
    [Parameter(Mandatory)]$aseName
)

$scriptRoot = $PSScriptRoot
$outputDir = $scriptRoot + "\output"
if (Test-Path -Path $outputDir) {
}
else {
    New-Item -Path $scriptRoot -Name "output" -ItemType "directory"
}

$outputFile = $outputDir + "\" + $aseName + ".csv"
Add-Content -Path $outputFile -Value '"WebAppName","ResourceGroup","Action","targetWebAppName","targetResourceGroup","targetAppServicePlan","targetAzureRegion","storageAccountResourceGroup","storageAccountName","containerName"'
Write-Host "Retrieving applications for App Service Environment" $aseName"..."
$appServicePlans = az appservice ase list-plans --name $aseName --resource-group $aseResourceGroupName | ConvertFrom-Json
$appServicePlans | ForEach-Object {
    $query = "[?appServicePlanId=='" + $_.id + "']"
    $webapps = az webapp list --query $query --resource-group $aseResourceGroupName | ConvertFrom-Json
    $webapps | ForEach-Object {
        if ($_.kind -eq "app") {
            $action = "clone"
        }
        else {
            $action = "backuprestore"
        }
        $webapp = '"' + $_.name + '","' + $_.resourceGroup + '","' + $action + '","","","","","","",""'
        Add-Content -Path $outputFile -Value $webapp
    }
}
Write-Host "Output file is located at" $outputFile -ForegroundColor Green