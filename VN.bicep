param deploymentInfo object
param stage object
param global object

var virtualNetworkInfo = deploymentInfo.virtualNetworkInfo

module VN 'VN-virtualnetwork.bicep' = [for (vn, index) in virtualNetworkInfo: {
  name: 'dp-vnetdeploy-${vn.name}'
  params: {
    virtualNetworkInfo: vn
    global: global
  }
}]
