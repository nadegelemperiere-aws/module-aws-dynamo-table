# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws dynamodb with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @21 january 2021
# Latest revision: 30 november 2023
# -------------------------------------------------------

# -------------------------------------------------------
# Create the dynamodb
# -------------------------------------------------------
resource "aws_dynamodb_table" "table" {

    name = "${var.project}-${var.environment}-${var.region}-${var.name}"

    read_capacity      = var.capacity.read
    write_capacity     = var.capacity.write

    billing_mode       = "PROVISIONED"

    hash_key           = var.hash
    range_key          = var.range

    server_side_encryption {
        enabled     = true
        kms_key_arn = aws_kms_key.table.arn
    }

    point_in_time_recovery {
        enabled     = true
    }

    dynamic "attribute" {
        for_each = var.attributes
        content {
            name = attribute.value.name
            type = attribute.value.type
        }
    }

    tags = {
        Name            = "${var.project}.${var.environment}.${var.module}.${var.region}.${var.name}.table"
        Environment     = var.environment
        Owner           = var.email
        Project         = var.project
        Version         = var.git_version
        Module          = var.module
    }
}


# -------------------------------------------------------
# Set permission policy for table access
# -------------------------------------------------------
locals {
    kms_statements = concat([
        for i,right in ((var.rights != null) ? var.rights : []) :
        {
            Sid           = right.description
            Effect        = "Allow"
            Principal     = {
                "AWS"         : ((right.principal.aws != null) ? right.principal.aws : [])
                "Service"     : ((right.principal.services != null) ? right.principal.services : [])
            }
            Action         = ["kms:Decrypt","kms:GenerateDataKey"],
            Resource    = ["*"]
        }
    ],
    [
        {
            Sid         = "AllowRootAndServicePrincipal"
            Effect         = "Allow"
            Principal     = {
                "AWS"         : ["arn:aws:iam::${var.account}:root", "arn:aws:iam::${var.account}:user/${var.service_principal}"]
            }
            Action         = "kms:*",
            Resource    = ["*"]
        }
    ])
}

# -------------------------------------------------------
# Table encryption key
# -------------------------------------------------------
resource "aws_kms_key" "table" {

    description                 = "Table ${var.name} encryption key"
    key_usage                    = "ENCRYPT_DECRYPT"
    customer_master_key_spec    = "SYMMETRIC_DEFAULT"
    deletion_window_in_days        = 7
    enable_key_rotation            = true
    policy                        = jsonencode({
          Version = "2012-10-17",
          Statement = local.kms_statements
    })

    tags = {
        Name            = "${var.project}.${var.environment}.${var.module}.${var.region}.${var.name}.table.key"
        Environment     = var.environment
        Owner           = var.email
        Project         = var.project
        Version         = var.git_version
        Module          = var.module
    }
}