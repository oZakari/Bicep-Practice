param deploymentInfo object
param stage object
param global object

var storageInfo = deploymentInfo.storageInfo

module SA 'SA-Storage.bicep' = [for (sa, index) in storageInfo: {
  name: 'dp-storagedeploy-${sa.name}'
  params: {
    storageInfo: sa
    global: global
  }
}]
