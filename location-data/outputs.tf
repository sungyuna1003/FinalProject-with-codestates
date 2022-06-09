output "opensearch_domain_arn" {
  value = aws_elasticsearch_domain.aos.arn
}

output "opensearch_domain_id" {
  value = aws_elasticsearch_domain.aos.domain_id
}

output "opensearch_domain_name" {
  value = aws_elasticsearch_domain.aos.domain_name
}

output "opensearch_domain_endpoint" {
  value = aws_elasticsearch_domain.aos.endpoint
}

output "opensearch_domain_kibana_endpoint" {
  value = aws_elasticsearch_domain.aos.kibana_endpoint
}