param deploymentInfo object
param stage object
param global object

var dataShareInfo = deploymentInfo.dataShareInfo

module DS 'DS-datashare.bicep' = [for (ds, index) in dataShareInfo: {
  name: 'dp-dsdeploy-${ds.name}'
  params:{
    dataShareInfo: ds
    global: global
  }
}]
