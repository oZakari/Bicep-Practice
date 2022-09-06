param deploymentInfo object
param stage object
param global object

var azSqlInfo = deploymentInfo.azSqlInfo

module AZSQL 'AZSQL-SQL.bicep' = [for (azsql, index) in azSqlInfo: {
  name: 'dp-azsqldeploy-${azsql.name}'
  params: {
    azSqlInfo: azsql
    global: global
  }
}]
