param SAName string
param fileshare object

resource SAFileService 'Microsoft.Storage/storageAccounts/fileServices@2021-06-01' existing = {
  name: '${SAName}/default'
}

resource SAFileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-09-01' = {
  name: toLower('${fileshare.name}')
  parent: SAFileService
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
}
