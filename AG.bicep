param deploymentInfo object
param stage object
param global object

var actionGroupInfo = deploymentInfo.actionGroupInfo

module AG 'AG-actiongroup.bicep' = [for (ag, index) in actionGroupInfo: {
  name: 'dp-ag-deploy-${ag.name}'
  params: {
    actionGroupInfo: ag
    global: global
  }
}]
