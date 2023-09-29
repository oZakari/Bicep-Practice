param azureFunctionInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource ASP 'Microsoft.Web/serverfarms@2022-09-01' existing = {
  name: azureFunctionInfo.asp
}

resource AI 'Microsoft.Insights/components@2020-02-02' existing = {
  name: azureFunctionInfo.ai
}

resource SA 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: azureFunctionInfo.sa
}

resource AF 'Microsoft.Web/sites@2021-02-01' = {
  name: toLower('${deployment}-${azureFunctionInfo.name}')
  location: resourceGroup().location
  kind: 'functionapp'
  properties: {
    enabled: true
    serverFarmId: ASP.id
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: AI.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${SA.name};AccountKey=${SA.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${SA.name};AccountKey=${SA.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('${deployment}-${azureFunctionInfo.name}')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'custom'
        }
      ]
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 1
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}
