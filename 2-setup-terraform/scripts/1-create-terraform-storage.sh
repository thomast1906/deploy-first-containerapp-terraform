#!/usr/bin/env bash
#set -x

# Creates the relevant storage account to store terraform state locally

RESOURCE_GROUP_NAME="voyagian-deploy-first-containerapp-rg"
STORAGE_ACCOUNT_NAME="vgiandeployfirstcntersa"

# Create Resource Group
az group create -l westus -n $RESOURCE_GROUP_NAME

# Create Storage Account
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l westus --sku Standard_LRS

# Create Storage Account blob
az storage container create  --name tfstate --account-name $STORAGE_ACCOUNT_NAME
