# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws dynamodb with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @21 january 2021
# Latest revision: 21 january 2021
# -------------------------------------------------------


terraform {
	experiments = [ module_variable_optional_attrs ]
}


# -------------------------------------------------------
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
    type     = string
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
    type     = string
}
variable "region" {
    type     = string
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
    type    = string
}
variable "module" {
    type     = string
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
    type    = string
    default = "unmanaged"
}

# -------------------------------------------------------
# Table name
# -------------------------------------------------------
variable "name" {
    type = string
}

# -------------------------------------------------------
# Table optimization
# -------------------------------------------------------
variable "hash" {
    type     = string
}
variable "range" {
    type     = string
    default = null
}
variable "attributes" {
    type = list(object({
        name = string
        type = string
    }))
}

# -------------------------------------------------------
# Table capacity (read / write units)
# -------------------------------------------------------
variable "capacity" {
    type = object({
        read    = number
        write   = number
    })
}

# --------------------------------------------------------
# Table table access rights + Service principal and account
# to ensure root and service principal can access
# --------------------------------------------------------
variable "rights" {
    type = list(object({
        description = string
        principal     = object({
            aws       = optional(list(string))
            services  = optional(list(string))
        })
    }))
    default = null
}
variable "service_principal" {
    type = string
}
variable "account" {
    type = string
}
