param deploymentInfo object
param stage object
param global object

var apiManagementInfo = deploymentInfo.apiManagementinfo

module AM 'AM-apimanagement.bicep' = [for (am, index) in apiManagementInfo: {
  name: 'dp-amdeploy-${am.name}'
  params: {
    apiManagementInfo: am
    global: global
  }
}]
