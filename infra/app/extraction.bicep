param location string
param tags object = {}
param cognitiveServicesName string
param functionAppStorageAccountName string
param documentStorageAccountName string
param eventGridTopicName string

param cognitiveServicesKind string = 'FormRecognizer'
param formRecognizerSkuName string = 'S0'

param appServicePlanId string
param functionName string
param allowedOrigins array = []
param appSettings object = {}
param applicationInsightsName string = ''
param keyVaultName string = ''

module sa1 '../core/storage/storage-account.bicep' = {
  name: 'functionAppStorageAccount'
  params: {
    name: functionAppStorageAccountName
    location: location
    tags: tags
  }
}

module sa2 '../core/storage/storage-account.bicep' = {
  name: 'documentStorageAccount'
  params: {
    name: documentStorageAccountName
    location: location
    tags: tags
    containers: [
      {
        name: '1-ingest'
      }
      {
        name: '2-extracted'
      }
      {
        name: '3-transformed'
      }
    ]
  }
}

// module formRecognizer '../core/ai/cognative.bicep' = {
//   name: 'formRecognizer'
//   params: {
//     cognitiveServicesName: cognitiveServicesName
//     cognitiveServicesKind: cognitiveServicesKind
//     location: location
//     tags: tags
//     sku: {
//       name: formRecognizerSkuName
//     }
//   }
// }

module function '../core/host/functions.bicep' = {
  name: 'function'
  params: {
    name: functionName
    location: location
    tags: union(tags, { 'azd-service-name': functionName })
    allowedOrigins: allowedOrigins
    alwaysOn: false
    appSettings: appSettings
    applicationInsightsName: applicationInsightsName
    appServicePlanId: appServicePlanId
    keyVaultName: keyVaultName
    //py
    numberOfWorkers: 1
    minimumElasticInstanceCount: 0
    //--py
    runtimeName: 'python'
    runtimeVersion: '3.11'
    functionStorageAccountName: functionAppStorageAccountName
    documentStorageAccountName: documentStorageAccountName
    scmDoBuildDuringDeployment: false
  }
}

// module eventgrid '../core/event/event-grid.bicep' = {
//   name: 'eventgrid'
//   params: {
//     eventGridTopicName: eventGridTopicName
//     location: location
//     tags: tags
//     storageAccountId: sa2.outputs.id
//   }
// }

output SERVICE_FUNCTION_IDENTITY_PRINCIPAL_ID string = function.outputs.identityPrincipalId
output SERVICE_FUNCTION_NAME string = function.outputs.name
output SERVICE_FUNCTION_URI string = function.outputs.uri
