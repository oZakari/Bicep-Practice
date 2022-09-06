param actionGroupInfo object 
param global object

var deployment = '${global.appName}-${global.environment}'

resource AG 'microsoft.insights/actionGroups@2019-06-01' = {
  name: toLower('${deployment}-${actionGroupInfo.name}')
  location: 'Global'
  properties: {
    groupShortName: 'SmartDetect'
    enabled: true
    emailReceivers: [for (er, index) in actionGroupInfo.emailReceivers: {
      name: '${er.name}-emailaction'
      emailAddress: er.emailAddress
      useCommonAlertSchema: er.useCommonAlertSchema
    }]
    armRoleReceivers: [for (ar, index) in actionGroupInfo.armRoleReceivers: {
      name: ar.name
      roleId: ar.roleId
      useCommonAlertSchema: ar.useCommonAlertSchema
    }]
    smsReceivers: []
    webhookReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
  }
}
