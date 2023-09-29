param SAName string
param fileshare object

resource SAFileService 'Microsoft.Storage/storageAccounts/fileServices@2023-01-01' existing = {
  name: '${SAName}/default'
}

resource SAFileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  name: toLower('${fileshare.name}')
  parent: SAFileService
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
}
