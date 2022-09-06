param customAlertInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource AF 'Microsoft.Web/sites@2021-03-01' existing = {
    name: customAlertInfo.af
}

resource AG 'microsoft.insights/actionGroups@2019-06-01' existing = {
    name: customAlertInfo.ag
}

resource AI 'microsoft.Insights/components@2020-02-02' existing = {
    name: customAlertInfo.ai
}

resource CA 'microsoft.insights/scheduledqueryrules@2021-02-01-preview' = {
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
