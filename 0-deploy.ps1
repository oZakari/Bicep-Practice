$rgname = 'zt-dev-bicep'
$region = 'East US 2'
Write-Warning -Message "RG is: [$rgname] in Region: [$region]"

$MyParametersDeployALL = @{
    ResourceGroupName     = $rgname
    TemplateParameterFile = ".\params\dev.json"
    Verbose               = $true
    WhatIf                = $false
}

break

New-AzResourceGroup -Name $rgname -Location $region -Force

# Orchestrate the deployment of all resources
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\ALL.bicep

# Deploy Single layer, inner dev loop - Action Group only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\AG.bicep

# Deploy Single layer, inner dev loop - Storage only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\SA.bicep

# Deploy Single layer, inner dev loop - VNET and subnets only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\VN.bicep

# Deploy Single layer, inner dev loop - NSG only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\NSG.bicep

# Deploy Single layer, inner dev loop - SQL Server only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\AZSQL.bicep

# Deploy Single layer, inner dev loop - App Service Plan only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\ASP.bicep

# Deploy Single layer, inner dev loop - Azure Function only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\AF.bicep

# Deploy Single layer, inner dev loop - Log Analytics only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\LA.bicep

# Deploy Single layer, inner dev loop - App Insights only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\AI.bicep

# Deploy Single layer, inner dev loop - API Management only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\AM.bicep

# Deploy Single layer, inner dev loop - Custom alert only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\CA.bicep

# Deploy Single layer, inner dev loop - Automation account only
New-AzResourceGroupDeployment @MyParametersDeployALL -TemplateFile .\AA.bicep