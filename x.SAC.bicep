param SAName string
param container object

resource SABlobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' existing = {
  name: '${SAName}/default'
}

resource SAContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: toLower('${container.name}')
  parent: SABlobService
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}
