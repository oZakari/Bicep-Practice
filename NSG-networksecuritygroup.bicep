param networkSecurityGroupInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource NSG 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: toLower('${deployment}-${networkSecurityGroupInfo.name}')
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}
