![Latest Release](https://img.shields.io/github/v/tag/impower-ai/uipath-ado-templates?style=flat-square)
![Last Update](https://img.shields.io/github/last-commit/impower-ai/uipath-ado-templates?style=flat-square)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
![Issues](https://img.shields.io/github/issues/impower-ai/uipath-ado-templates?style=flat-square)

# About
This repository contains YAML templates and Powershell scripts intended to be used with Azure DevOps pipelines. These templates simplify the process of creating staged pipelines, and also provide some extended functionality beyond what is included in the [UiPath Integration for Azure DevOps](https://marketplace.visualstudio.com/items?itemName=uipath.vsts-uipath-package)

# Usage
Create a [Github Service Connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#github-service-connection). In this example, it is called 'GithubConnection'. No special permissions are needed. Define to the reference to this repository in the beginning of your build pipeline:
```yaml
resources:
  repositories:
  - repository: impower
    type: github
    name: impower-ai/uipath-ado-templates
    endpoint: GithubConnection
    trigger: none
    #optional - add a ref to specify a version.
    ref: refs/tags/v22.06.09.14
```

You can then reference templates like this:

```yaml
stages:

# Build Package
- template: /templates/build-template.yml@impower
  parameters:
    service_connection: 'OrchestratorDevelopment'
    package_version: 'build'

# Deploy Development
- template: /templates/deploy-template.yml@impower
  parameters:
    service_connection: 'OrchestratorDevelopment'
    azure_environment: 'UiPathDevelopment'
    orchestrator_folder: 'MyProject'
    stage_name: 'DeployDevelopment'
    stage_dependencies:
    - 'Build'

# Deploy Staging
- template: /templates/deploy-template.yml@impower
  parameters:
    service_connection: 'OrchestratorDevelopment'
    azure_environment: 'UiPathDevelopment'
    orchestrator_folder: 'MyProject'
    stage_name: 'DeployStaging'
    stage_dependencies:
    - 'Build'
    
# Test In Staging
- template: /templates/test-template.yml@impower
  parameters:
    service_connection: 'OrchestratorStaging'
    orchestrator_folder: 'MyProject'
    stage_name: 'TestStaging'
    stage_dependencies:
    - 'DeployStaging'

# Deploy In Production
- template: /templates/deploy-template.yml@impower
  parameters:
    service_connection: 'OrchestratorProduction'
    azure_environment: 'UiPathProduction'
    orchestrator_folder: 'MyProject'
    stage_name: 'DeployProduction'
    stage_dependencies:
    - 'DeployDevelopment'
    - 'TestStaging'
```