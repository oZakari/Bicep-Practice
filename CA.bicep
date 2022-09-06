param deploymentInfo object
param stage object
param global object

var customAlertInfo = deploymentInfo.customAlertInfo

module CA 'CA-CustomAlert.bicep' = [for (ca, index) in customAlertInfo: {
  name: 'dp-customalertdeploy-${ca.name}'
  params: {
    customAlertInfo: ca
    global: global
  }
}]
