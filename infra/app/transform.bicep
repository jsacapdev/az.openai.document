param location string
param cognitiveServicesName string
param tags object = {}

param openAiSkuName string = 'S0'
param chatGptModelName string = 'gpt-35-turbo'
param chatGptModelVersion string = '0301'
param embeddingModelName string = 'text-embedding-ada-002'
param chatGptDeploymentCapacity int = 30
param embeddingDeploymentCapacity int = 30
param cognitiveServicesKind string = 'OpenAI'

module openai '../core/ai/cognative.bicep' = {
  name: 'openai'
  params: {
    name: cognitiveServicesName
    kind: cognitiveServicesKind
    location: location
    tags: tags
    sku: {
      name: openAiSkuName
    }
    deployments: [
      {
        name: chatGptModelName
        model: {
          format: 'OpenAI'
          name: chatGptModelName
          version: chatGptModelVersion
        }
        sku: {
          name: 'Standard'
          capacity: chatGptDeploymentCapacity
        }
      }
      {
        name: embeddingModelName
        model: {
          format: 'OpenAI'
          name: embeddingModelName
          version: '2'
        }
        capacity: embeddingDeploymentCapacity
      }
    ]
  }
}
