param deploymentInfo object
param stage object
param global object

var networkSecurityGroupInfo = deploymentInfo.networkSecurityGroupInfo

module NSG 'NSG-networksecuritygroup.bicep' = [for (nsg, index) in networkSecurityGroupInfo: {
  name: 'dp-nsgdeploy-${nsg.name}'
  params: {
    networkSecurityGroupInfo: nsg
    global: global
  }
}]
