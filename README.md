# Eneco Data Pipeline POC

This repository contains a **proof of concept (POC)** data pipeline for Eneco, demonstrating how to build and orchestrate data ingestion, transformation, and automation using **Azure Databricks** and **Azure DevOps**. Infra code contains the necessary Terraform configurations to set up the required Azure resources, including Databricks, storage, and networking.

## Overview

The solution includes:

- **Azure Databricks** for scalable data processing and analytics
- **Azure DevOps** for CI/CD automation, deployment, and governance
- Automated ingestion of CSV datasets from URLs
- Transformations to compute:
  - Longest and shortest runways per country
  - Top 3 and bottom 10 countries by number of airports
- Jobs orchestrated and scheduled using Databricks Workflows

## Why we chose this workflow orchestration

We chose **Azure Databricks Workflows** for orchestration because:

- It provides tight integration with the Databricks runtime environment — no additional orchestration tool required for this scope.
- It simplifies dependency management between tasks (e.g., ingestion → transformation).
- It offers built-in scheduling, monitoring, and alerting.


We integrated this with **Azure DevOps** to:

- Enable version control, CI/CD, and traceability
- Provide a familiar pipeline and deployment framework


## Instructions

### Prerequisites

- Azure Databricks workspace (Premium SKU or higher)
- Azure DevOps project and repository
- Databricks PAT token stored securely in Azure DevOps variable group (e.g., `databricks-secrets`)
- Azure Storage account with public blob endpoint (for this POC)

### Structure
```
cicd/
└── pipelines/
├── deploy_notebook.yaml
└── pr-validation.yaml

dev/
├── ingest/
│ └── 01_ingestion.py # Ingests CSV from URLs and saves as Delta tables
└── transform/
└── 01_transformation.py # Computes runway stats and airport counts

infra/
└── terraform/
├── _config_files/
│ └── product_configuration.yaml
├── base/
│ ├── .terraform.lock.hcl
│ └── terragrunt.hcl
├── functional/
│ ├── .terraform.lock.hcl
│ └── terragrunt.hcl
└── modules/
├── base/
│ ├── databricks/
│ ├── services_subnet/
│ ├── storage/
│ ├── main.tf
│ ├── outputs.tf
│ ├── README.md
│ ├── variables.tf
│ └── versions.tf
└── functional/
├── databricks/
├── locals.tf
├── main.tf
├── README.md
├── variables.tf
└── versions.tf
```
### Terraform IaC

The infrastructure is defined using **Terraform** with the following components:
- **Storage Account**: For storing raw and processed data
- **Databricks Workspace**: For running notebooks and jobs 
- **Networking**: Virtual network and subnets for secure access
- **Unity Catalog**: For data governance and access control

The following environment variables are required for the Terraform deployment:
- `TFSTATE_SUBSCRIPTION_ID`:  Azure Subscription ID
- `TFSTATE_RESOURCE_GROUP_NAME`: Azure Resource Group for Terraform state
- `CLIENT_SECRET`: Azure Service Principal Client Secret
- `PRODUCT_CONFIGURATION_FILE`: Path to the product configuration file (e.g., `infra/terraform/_config_files/product_configuration.yaml`) 

Some componentes of the infrastrucutre have been pre implemented before terraform was used, such as virtual network, storage account for remote. The Terraform code is designed to be idempotent, meaning it can be run multiple times without causing issues.



### CI/CD Pipelines

We provide two Azure DevOps pipelines:

1. **PR pipeline**
   - Runs on pull request updates
   - Validates code via linting and unit tests
   - No deployment happens

2. **Deployment pipeline**
   - Triggers on `main` branch changes
   - Runs only if files change in `dev/ingest/` or `dev/transform/`
   - Uploads notebooks to Databricks workspace
   - Creates or updates Databricks jobs with scheduling

### How to deploy

- On PR creation → PR pipeline runs automatically
- On merge to `main` → Deployment pipeline runs automatically
- Pipelines are defined in `cicd/` folder

## Approach

- **Code-first:** Notebooks/scripts stored in Git, treated as deployable artifacts
- **Secret-free notebooks:** Databricks managed identity + ABFSS URLs, no hard-coded keys
- **Databricks CLI:** Used by Azure DevOps pipelines to interact with Databricks workspace
- **Terraform:** Used for IaC around storage, Databricks, Unity Catalog

## Assumptions

- Unity Catalog is enabled and the metastore assigned to the workspace
- The Databricks cluster has access to storage (via managed identity)
- Public blob endpoints are accessible for dataset download (no private endpoint enforced for POC)

# Data Pipeline - RBAC Solution

The RBAC (Role-Based Access Control) solution for the Eneco data pipeline 

## Azure RBAC

| **Role** | **Scope** | **Who?** | **Purpose** |
|-----------|-----------|----------|-------------|
| Storage Blob Data Contributor | Storage account | Databricks managed identity | Access ADLS Gen2 (read/write blobs) |
| Reader | Resource group | Data engineers | View Azure resources |
| Contributor (optional) | Resource group | DevOps | Manage Azure resources |


## Challenges

- Setting up Unity Catalog requires manual enablement at the Databricks account level (no direct Terraform support for initial activation)
- Coordinating cluster ID and environment-specific configs across pipelines
- Managing job idempotency when creating or updating jobs via CLI (no direct upsert in CLI)

## Improvement ideas

- Replace CLI-based job management with **Terraform-managed jobs** for better idempotency and code clarity
- Add **unit and integration tests** for transformation logic (e.g., validate outputs match expected results)
- Extend pipelines to include **data quality checks** and **automated rollback on failure**
- Enable **approvals** in Azure DevOps for production deployments
- Implement **monitoring and alerting** for job failures using Azure Monitor or Databricks alerts
- Enable databricks policies for cost control over clusters and jobs


