metadata description = 'Creates an Azure event grid topic.'
param eventGridTopicName string
param eventSubName string = 'document-created'
param endpoint string = 'https://b077-4-234-215-42.ngrok.io/runtime/webhooks/blobs?functionName=Host.Functions.DocumentCreatedTrigger'
param location string = resourceGroup().location
param tags object = {}
param storageAccountId string

resource systemTopic 'Microsoft.EventGrid/systemTopics@2023-06-01-preview' = {
  name: eventGridTopicName
  location: location
  tags: tags
  properties: {
    source: storageAccountId
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}

resource eventSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-12-01' = {
  parent: systemTopic
  name: eventSubName
  properties: {
    destination: {
      properties: {
        endpointUrl: endpoint
      }
      endpointType: 'WebHook'
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
        'Microsoft.Storage.BlobDeleted'
      ]
    }
  }
}
