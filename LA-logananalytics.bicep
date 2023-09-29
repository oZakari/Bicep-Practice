param logAnalyticsInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource LA 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: toLower('${deployment}-${logAnalyticsInfo.name}')
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}
