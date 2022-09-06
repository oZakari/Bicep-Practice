param global object
param automationAccountInfo object

var deployment = '${global.appName}-${global.environment}'

resource AA 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: toLower('${deployment}-${automationAccountInfo.name}')
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    disableLocalAuth: false
    sku: {
      name: 'Basic'
    }
    encryption: {
      keySource: 'Microsoft.Automation'
      identity: {}
    }
  }
}
