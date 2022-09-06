param deploymentInfo object
param stage object
param global object

var applicationInsightsInfo = deploymentInfo.applicationInsightsInfo

module AI 'AI-appinsights.bicep' = [for (ai, index) in applicationInsightsInfo:{
  name: 'dp-aideploy-${ai.name}'
  params: {
    applicationInsightsInfo: ai
    global: global
  }  
}]
