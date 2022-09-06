param SAName string
param queue object

resource SAQueueService 'Microsoft.Storage/storageAccounts/queueServices@2021-06-01' existing = {
  name: '${SAName}/default'
}

resource SAQueues 'Microsoft.Storage/storageAccounts/queueServices/queues@2021-09-01' = {
  name: toLower('${queue.name}')
  parent: SAQueueService
  properties: {
    metadata: {}
  }
}
