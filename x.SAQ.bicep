param SAName string
param queue object

resource SAQueueService 'Microsoft.Storage/storageAccounts/queueServices@2023-01-01' existing = {
  name: '${SAName}/default'
}

resource SAQueues 'Microsoft.Storage/storageAccounts/queueServices/queues@2023-01-01' = {
  name: toLower('${queue.name}')
  parent: SAQueueService
  properties: {
    metadata: {}
  }
}
