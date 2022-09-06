param AZSQLName string
param allowedip object

resource AZSQL 'Microsoft.Sql/servers@2021-02-01-preview' existing = {
  name: AZSQLName
}

resource AZSQL_FirewallRules 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  parent: AZSQL
  name: allowedip.name
  properties: {
    startIpAddress: allowedip.startip
    endIpAddress: allowedip.endip
  }
}
