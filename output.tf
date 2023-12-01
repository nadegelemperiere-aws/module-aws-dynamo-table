# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws dynamodb with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @21 january 2021
# Latest revision: 21 january 2021
# -------------------------------------------------------


output "id" {
    value = aws_dynamodb_table.table.id
}

output "arn" {
    value = aws_dynamodb_table.table.arn
}

output "key" {
    value = aws_kms_key.table.arn
}