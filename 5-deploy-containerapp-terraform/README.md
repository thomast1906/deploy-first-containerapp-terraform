# Deploy Container App using Terraform

Now that the test application has been built and deployed into ACR, time to deploying the container app with image built on previous stage [4-build-deploy-application-to-acr](https://github.com/thomast1906/deploy-first-containerapp-terraform/tree/main/4-Build-deploy-application-to-ACR)

In this lab you will deploy using Terraform:
- Azure Container Environment
- Azure Managed Identity
- Azure IAM to allow the Managed Identity `acrpull` permissions from the ACR previously created
- Azure Container App with Managed Identity and deploy application into Container App
