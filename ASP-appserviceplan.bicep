param appServicePlanInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource ASP 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: toLower('${deployment}-${appServicePlanInfo.name}')
  location: resourceGroup().location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}
