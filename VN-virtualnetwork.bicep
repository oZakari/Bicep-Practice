param virtualNetworkInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource VN 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: toLower('${deployment}-${virtualNetworkInfo.name}')
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: virtualNetworkInfo.subnetOne
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
      {
        name: virtualNetworkInfo.subnetTwo
        properties: {
          addressPrefix: '10.10.2.0/24'
        }
      }
    ]
  }
}
