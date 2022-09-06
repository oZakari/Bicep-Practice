param deploymentInfo object
param stage object
param global object

var logAnalyticsInfo = deploymentInfo.logAnalyticsInfo

module LA 'LA-logananalytics.bicep' = [for (la, index) in logAnalyticsInfo: {
  name: 'dp-ladeploy-${la.name}'
  params:{
    logAnalyticsInfo: la
    global: global
  }
}]
