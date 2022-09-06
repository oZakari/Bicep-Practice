param deploymentInfo object
param stage object
param global object

var appServicePlanInfo = deploymentInfo.appServicePlanInfo

module ASP 'ASP-appserviceplan.bicep' = [for (asp, index) in appServicePlanInfo: {
  name: 'dp-aspdeploy-${asp.name}'
  params: {
    appServicePlanInfo: asp
    global: global
  }
}]
