param deploymentInfo object
param stage object
param global object

var automationAccountInfo = deploymentInfo.automationAccountInfo

module AA 'AA-automationaccount.bicep' = [for (aa, index) in automationAccountInfo: {
  name: 'dp-automationaccountdeploy-${aa.name}'
  params:{
    automationAccountInfo: aa
    global: global
  }
}]
