param dataShareInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource symbolicname 'Microsoft.DataShare/accounts@2021-08-01' = {
  name: toLower('${deployment}-${dataShareInfo.name}')
  location: resourceGroup().location
 identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}
