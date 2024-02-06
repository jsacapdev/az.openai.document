targetScope = 'resourceGroup'

@minLength(1)
@maxLength(10)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@maxLength(64)
@description('Name of the product that can be used as part of naming resource convention')
param productName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Id of the user or app to assign application roles')
param principalId string

var abbrs = loadJsonContent('./abbreviations.json')

// Tags that should be applied to all resources.
var tags = {
  'azd-env-name': environmentName
}

// monitoring
module monitoring './core/monitor/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${productName}-${environmentName}-001'
    location: location
    tags: tags
    applicationInsightsName: '${abbrs.insightsComponents}${productName}-${environmentName}-001'
    applicationInsightsDashboardName: '${abbrs.portalDashboards}${productName}-${environmentName}-001'
  }
}

// Store secrets in a keyvault
module keyVault './core/security/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    name: '${abbrs.keyVaultVaults}${productName}-${environmentName}-001'
    location: location
    tags: tags
    principalId: principalId
  }
}

// Create an App Service Plan to group applications under the same payment plan and SKU
module appServicePlan './core/host/appserviceplan.bicep' = {
  name: 'appserviceplan'
  params: {
    name: '${abbrs.webServerFarms}${productName}-${environmentName}-001'
    location: location
    tags: tags
    sku: {
      name: 'P1v2'
      tier: 'PremiumV2'
    }
  }
}

// text extraction
module extract './app/extract.bicep' = {
  name: 'extraction'
  params: {
    tags: tags
    functionAppStorageAccountName: '${abbrs.storageStorageAccounts}${productName}${environmentName}001'
    documentStorageAccountName: '${abbrs.storageStorageAccounts}${productName}${environmentName}002'
    eventGridTopicName: '${abbrs.eventGridDomainsTopics}${productName}-${environmentName}-001'
    location: location
    cognitiveServicesName: '${abbrs.cognitiveServicesFormRecognizer}${productName}-${environmentName}-001'
    functionName: '${abbrs.webSitesFunctions}${productName}-${environmentName}-001'
    appServicePlanId: appServicePlan.outputs.id
    appSettings: {
      AzureWebJobsFeatureFlags: 'EnableWorkerIndexing'
    }
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    keyVaultName: '${abbrs.keyVaultVaults}${productName}-${environmentName}-001'
  }
}

// Give the extract function access to KeyVault
module extractKeyVaultAccess './core/security/keyvault-access.bicep' = {
  name: 'extract-keyvault-access'
  params: {
    keyVaultName: keyVault.outputs.name
    principalId: extract.outputs.SERVICE_FUNCTION_IDENTITY_PRINCIPAL_ID
  }
}

// transform
module transform './app/transform.bicep' = {
  name: 'transform'
  params: {
    tags: tags
    location: location
    cognitiveServicesName: '${abbrs.cognitiveServicesAccounts}${productName}-${environmentName}-001'
  }
}

// Add outputs from the deployment here, if needed.
//
// This allows the outputs to be referenced by other bicep deployments in the deployment pipeline,
// or by the local machine as a way to reference created resources in Azure for local development.
// Secrets should not be added here.
//
// Outputs are automatically saved in the local azd environment .env file.
// To see these outputs, run `azd env get-values`,  or `azd env get-values --output json` for json output.
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
