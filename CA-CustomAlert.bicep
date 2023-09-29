param customAlertInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource AF 'Microsoft.Web/sites@2022-09-01' existing = {
    name: customAlertInfo.af
}

resource AG 'Microsoft.Insights/actionGroups@2023-01-01' existing = {
    name: customAlertInfo.ag
}

resource AI 'Microsoft.Insights/components@2020-02-02' existing = {
    name: customAlertInfo.ai
}

resource CA 'Microsoft.Insights/scheduledQueryRules@2022-06-15' = {
  name: toLower('${deployment}-${customAlertInfo.name}')
  location: resourceGroup().location
  properties: {
    displayName: 'failed-operation'
    severity: 1
    enabled: true
    evaluationFrequency: 'PT5M'
    scopes: [
      AI.id
    ]
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          query: 'requests\r\n| join kind=inner exceptions on operation_Id\r\n| where success == \'False\'\r\n| summarize any(timestamp, operation_Id, duration) by innermostMessage'
          timeAggregation: 'Count'
          operator: 'GreaterThanOrEqual'
          threshold: 1
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
    actions: {
      actionGroups: [
        AG.id
      ]
    }
  }
}
