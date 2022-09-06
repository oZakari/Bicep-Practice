param storageInfo object
param global object

var deployment = '${global.appName}${global.environment}'

var fileshares = contains(storageInfo, 'fileshares') ? storageInfo.fileshares : []
var containers = contains(storageInfo, 'containers') ? storageInfo.containers : []
var queues = contains(storageInfo, 'queues') ? storageInfo.queues : []

resource SA 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: toLower('${deployment}${storageInfo.name}')
  location: resourceGroup().location
  sku: {
    name: storageInfo.skuName
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: storageInfo.publicAccess
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource SABlobService 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  name: '${toLower('${deployment}${storageInfo.name}')}/default'
  properties: {
    isVersioningEnabled: (contains(storageInfo, 'blobVersioning') ? storageInfo.blobVersioning : bool('false'))
    changeFeed: {
      enabled: (contains(storageInfo, 'changeFeed') ? storageInfo.changeFeed : bool('false'))
    }
    deleteRetentionPolicy: (contains(storageInfo, 'softDeletePolicy') ? storageInfo.softDeletePolicy : json('null'))
  }
  dependsOn: [
    SA
  ]
}

resource SAFileService 'Microsoft.Storage/storageAccounts/fileServices@2021-04-01' = {
  name: 'default'
  parent: SA
}

resource SAQueueService 'Microsoft.Storage/storageAccounts/queueServices@2021-04-01' = {
  name: 'default'
  parent: SA
}

resource SATableService 'Microsoft.Storage/storageAccounts/tableServices@2021-04-01' = {
  name: 'default'
  parent: SA
}

module SAContainers 'x.SAC.bicep' = [for (container, index) in containers : {
  name: 'dp-storagecontainerdeploy-${storageInfo.name}-${container.name}'
  params: {
    SAName: SA.name
    container: container
  }
}]

module SAFileshares 'x.SAF.bicep' = [for (fileshare, index) in fileshares : {
  name: 'dp-storagefilesharedeploy-${storageInfo.name}-${fileshare.name}'
  params: {
    SAName: SA.name
    fileshare: fileshare
  }
}]

module SAQueues 'x.SAQ.bicep' = [for (queue, index) in queues : {
  name: 'dp-storagequeuedeploy-${storageInfo.name}-${queue.name}'
  params: {
    SAName: SA.name
    queue: queue
  }
}]
