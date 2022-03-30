![Latest Release](https://img.shields.io/github/v/tag/impower-ai/uipath-ado-templates?style=flat-square)
![Last Update](https://img.shields.io/github/last-commit/impower-ai/uipath-ado-templates?style=flat-square)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

# About
This repository contains YAML templates and Powershell scripts intended to be used with Azure DevOps pipelines. These templates simplify the process of creating staged pipelines, and also provide some extended functionality beyond what is included in the [UiPath Integration for Azure DevOps](https://marketplace.visualstudio.com/items?itemName=uipath.vsts-uipath-package)

# Usage
Create a [Github Service Connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#github-service-connection) (in this example, called 'GithubConnection' in your Azure DevOps project. No special permissions are needed. Define to the reference to this repository in the beginning of your build pipeline:
```yaml
resources:
  repositories:
  - repository: impower
    type: github
    name: impower-ai/uipath-ado-templates
    endpoint: GithubConnection
    trigger: none
    #optional - add a ref to specify a version.
    ref: refs/tags/v03.30.22
```
You can then reference templates like this:
```yaml
stages:
- template: /templates/some-template.yaml@impower
  parameters:
    project_name: "ExampleProject"
    stage_name: 'Development'
    deploy_environment: 'Development'
```
