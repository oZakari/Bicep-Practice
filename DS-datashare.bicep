param dataShareInfo object
param global object

var deployment = '${global.appName}-${global.environment}'

resource SQLServer 'Microsoft.Sql/servers@2022-02-01-preview' existing = {
  name: dataShareInfo.sqlservername
  scope: resourceGroup('Practice')

}

resource DS 'Microsoft.DataShare/accounts@2021-08-01' = {
  name: toLower('${deployment}-${dataShareInfo.name}')
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

resource DSShare 'Microsoft.DataShare/accounts/shares@2021-08-01' = if (dataShareInfo.sender == true) {
  name: '${toLower('${deployment}-${dataShareInfo.name}')}-share'
  parent: DS
  properties: {
    shareKind: 'CopyBased'
  }
}

resource DSDataSet 'Microsoft.DataShare/accounts/shares/dataSets@2021-08-01' = if (dataShareInfo.sender == true) {
  name: '${toLower('${deployment}-${dataShareInfo.name}')}-dataset'
  kind: 'SqlDBTable'
  parent: DSShare
  properties: {
    databaseName: 'zttest'
    schemaName: 'dbo'
    sqlServerResourceId: SQLServer.id
    tableName: 'myTable'
  }
}

resource Invitation 'Microsoft.DataShare/accounts/shares/invitations@2021-08-01' = if (dataShareInfo.sender == true) {
  dependsOn: [
    DSDataSet
  ]
  parent: DSShare
  name: '${toLower('${deployment}-${dataShareInfo.name}')}-invite'
  properties: {
    targetEmail: 'ztrocinski@microsoft.com'
  }
}

resource DSSender 'Microsoft.DataShare/accounts@2021-08-01' existing = {
  name: toLower('${deployment}-${dataShareInfo.sendersuffix}')

  resource DSSenderShare 'shares' existing = {
    name: '${toLower('${deployment}-${dataShareInfo.sendersuffix}')}-share'

    resource DSSenderInvitation 'invitations' existing = {
      name: '${toLower('${deployment}-${dataShareInfo.sendersuffix}')}-invite'
    }
  }
}

// resource DSSenderMap 'Microsoft.DataShare/accounts@2021-08-01' existing = {
//   name: toLower('${deployment}-${dataShareInfo.sendersuffix}')

//   resource DSSenderShareMap 'shares' existing = {
//     name: '${toLower('${deployment}-${dataShareInfo.sendersuffix}')}-share'

//     resource DSSenderDataset 'dataSets' existing = {
//       name: '${toLower('${deployment}-${dataShareInfo.sendersuffix}')}-dataset'
//     }
//   }
// }

resource ShareSubscription 'Microsoft.DataShare/accounts/shareSubscriptions@2021-08-01' = if (dataShareInfo.sender == false) {
  dependsOn: [
    Invitation
  ]
  name: '${toLower('${deployment}-${dataShareInfo.name}')}-sharesub'
  parent: DS
  properties: {
    invitationId: dataShareInfo.sender == false ? DSSender::DSSenderShare::DSSenderInvitation.properties.invitationId : ''
    sourceShareLocation: resourceGroup().location
  }
}

resource GetDataSetGuidScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  dependsOn: [
    ShareSubscription
  ]
  name: '${toLower('${deployment}-${dataShareInfo.name}')}-getdatasetid'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: 'latest'
    timeout: 'PT1H'
    arguments: ''
    scriptContent: '''
      (Get-AzDataShareSourceDataSet -ResourceGroupName "zt-dev-bicep" -AccountName "zt-dev-ds2" -ShareSubscriptionName "zt-dev-ds2-sharesub").DataSetId
    '''
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
  }
}

output output string = GetDataSetGuidScript.properties.outputs.text

resource DataSetMapping 'Microsoft.DataShare/accounts/shareSubscriptions/dataSetMappings@2021-08-01' = if (dataShareInfo.sender == false)  {
  dependsOn: [
    GetDataSetGuidScript
  ]
  parent: ShareSubscription
  name: '${toLower('${deployment}-${dataShareInfo.name}')}-mapping'
  kind: 'SqlDBTable'
  properties: {
    databaseName: 'zttest'
    schemaName: 'dbo'
    dataSetId: GetDataSetGuidScript.properties.outputs.text
    sqlServerResourceId: SQLServer.id
    tableName: 'myTable'
  }
}




