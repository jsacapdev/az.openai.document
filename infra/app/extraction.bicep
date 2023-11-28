param location string
param tags object = {}
param storageAccountName1 string
param storageAccountName2 string
param eventGridTopicName string

module sa1 '../core/storage/storage-account.bicep' = {
  name: 'storageAccount1'
  params: {
    name: storageAccountName1
    location: location
    tags: tags
  }
}

module sa2 '../core/storage/storage-account.bicep' = {
  name: 'storageAccount2'
  params: {
    name: storageAccountName2
    location: location
    tags: tags
    containers: [
      {
        name: 'doc-input'
      }
      {
        name: 'doc-output'
      }
    ]
  }
}

module eventgrid '../core/event/event-grid.bicep' = {
  name: 'eventgrid'
  params: {
    eventGridTopicName: eventGridTopicName
    location: location
    tags: tags
    storageAccountId: sa2.outputs.id
  }
}
