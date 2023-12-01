# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Simple deployment for testing
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------


# -------------------------------------------------------
# Local test variables
# -------------------------------------------------------
locals {
    test_tables = [
        {    name = "test-1", attributes = [{name = "LockID", type = "S"}], capacity = {read = 5, write = 5}, hash = "LockID" },
        {    name = "test-2", attributes = [{name = "LockID", type = "S"}], capacity = {read = 1, write = 1}, hash = "LockID" }
    ]
}

# -------------------------------------------------------
# Create tables using the current module
# -------------------------------------------------------
module "tables" {

    count               = length(local.test_tables)

    source              = "../../../"
    email               = "moi.moi@moi.fr"
    project             = "test"
    environment         = "test"
    region              = var.region
    module              = "test"
    git_version         = "test"
    service_principal   = var.service_principal
    account             = var.account
    name                = local.test_tables[count.index].name
    capacity            = lookup("${local.test_tables[count.index]}", "capacity", null)
    hash                = lookup("${local.test_tables[count.index]}", "hash", null)
    range               = lookup("${local.test_tables[count.index]}", "range", null)
    attributes          = lookup("${local.test_tables[count.index]}", "attributes", [])
}

# -------------------------------------------------------
# Terraform configuration
# -------------------------------------------------------
provider "aws" {
    region        = var.region
    access_key    = var.access_key
    secret_key    = var.secret_key
}

terraform {
    required_version = ">=1.0.8"
    backend "local"    {
        path="terraform.tfstate"
    }
}

# -------------------------------------------------------
# Region for this deployment
# -------------------------------------------------------
variable "region" {
    type    = string
}

# -------------------------------------------------------
# AWS credentials
# -------------------------------------------------------
variable "access_key" {
    type        = string
    sensitive     = true
}
variable "secret_key" {
    type        = string
    sensitive     = true
}

# -------------------------------------------------------
# IAM account which root to use to test access rights settings
# -------------------------------------------------------
variable "account" {
    type         = string
    sensitive    = true
}
variable "service_principal" {
    type         = string
    sensitive    = true
}

# -------------------------------------------------------
# Test outputs
# -------------------------------------------------------
output "tables" {
    value = {
        id         = module.tables.*.id
        arn        = module.tables.*.arn
    }
}
output "keys" {
    value = module.tables.*.key
}
