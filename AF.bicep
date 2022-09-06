param deploymentInfo object
param stage object
param global object

var azureFunctionInfo = deploymentInfo.azureFunctionInfo

module AF 'AF-function.bicep' = [for (af, index) in azureFunctionInfo: {
  name: 'dp-afdeploy-${af.name}'
  params: {
    global: global
    azureFunctionInfo: af
  }
}]

