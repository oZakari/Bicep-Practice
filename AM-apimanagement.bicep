param apiManagementInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource VN 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: apiManagementInfo.vn
  scope: resourceGroup(apiManagementInfo.vnrg)
}

resource AM 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: toLower('${deployment}-${apiManagementInfo.name}')
  location: resourceGroup().location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publisherEmail: 'nanalluri@saws.org'
    publisherName: 'SAWS'
    notificationSenderEmail: 'apimgmt-noreply@mail.windowsazure.com'
    hostnameConfigurations: []
    virtualNetworkConfiguration: {
      subnetResourceId: '${VN.id}/subnets/api'
    }
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'False'
    }
    virtualNetworkType: 'Internal'
    apiVersionConstraint: {
    }
    publicNetworkAccess: 'Enabled'
  }
}
