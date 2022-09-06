param azSqlInfo object
param global object

var deployment = '${global.appName}-${global.environment}'
var allowedips = contains(azSqlInfo, 'allowedips') ? azSqlInfo.allowedips : []

resource AZSQL 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: toLower('${deployment}-${azSqlInfo.name}')
  location: resourceGroup().location
  properties: {
    administratorLogin: azSqlInfo.adminLogin
    administratorLoginPassword: azSqlInfo.adminPw
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }  
}

module AZSQL_FirewallRules 'x.FWR.bicep' = [for (allowedip, index) in allowedips: {
  name: 'dp-allowedipsdeploy-${azSqlInfo.name}-${allowedip.name}'
  params: {
    AZSQLName: AZSQL.name
    allowedip: allowedip
  }
}]

