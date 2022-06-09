resource "null_resource" "aos_service_linked_role" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<-COMMAND
      aws iam create-service-linked-role --aws-service-name es.amazonaws.com
    COMMAND
    on_failure = continue
  }
}

data "aws_iam_role" "aos_service_linked_role" {
  name = "AWSServiceRoleForAmazonElasticsearchService"

  depends_on = [
    null_resource.aos_service_linked_role
  ]
}

resource "aws_elasticsearch_domain" "aos" {
  domain_name = var.aos_domain_name
  elasticsearch_version = var.opensearch_version

  cluster_config {
    instance_count = var.aos_data_instance_count
    instance_type = var.aos_data_instance_type
    dedicated_master_enabled = var.aos_master_instance_count > 0
    dedicated_master_count = var.aos_master_instance_count
    dedicated_master_type = var.aos_master_instance_type
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.aos_data_instance_storage
  }

  encrypt_at_rest {
    enabled = var.aos_encrypt_at_rest
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  access_policies = data.aws_iam_policy_document.aos_access_policies.json
    
  advanced_security_options {
    enabled = true 
    internal_user_database_enabled = true
    master_user_options {
      master_user_name = "admin"                #Options
      master_user_password = "Qwer1234*"        #Options
    }
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
    log_type = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
    log_type = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_logs.arn
    log_type = "ES_APPLICATION_LOGS"
  }

  tags = var.tags

  depends_on = [data.aws_iam_role.aos_service_linked_role]
}

data "aws_iam_policy_document" "aos_access_policies" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["*"]
      }
    actions = [
      "es:*"
    ]
    resources = [
      "arn:aws:es:${local.aws_region}:${local.aws_account_id}:domain/${var.aos_domain_name}/*"
    ]
  }
}

resource "aws_cloudwatch_log_group" "opensearch_logs" {
  name = "opensearch/${var.aos_domain_name}"
}

resource "aws_cloudwatch_log_resource_policy" "opensearch_logs" {
  policy_name = "opensearch-${var.aos_domain_name}"
  policy_document = data.aws_iam_policy_document.opensearch_logs.json
}

data "aws_iam_policy_document" "opensearch_logs" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
      "logs:CreateLogStream",
    ]
    resources = [
      "arn:aws:logs:*"
    ]
  }
}