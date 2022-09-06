param SAName string
param container object

resource SABlobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' existing = {
  name: '${SAName}/default'
}

resource SAContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
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
