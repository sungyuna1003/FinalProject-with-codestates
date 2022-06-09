variable "project_name" {
  type = string
  default = "terraform-domain"
}

variable "availability_zone" {
  type = string
  default = "a"
}

#############################################

variable "tags" {
  type = map
  default = {}
}

variable "aos_domain_name" {
  type = string
  default = "terraform-domain"
  //description = "Name for Elasticsearch domain, also used as prefix for related resources."
}

variable "opensearch_version" {
  type = string
  default = "OpenSearch_1.2"
}

variable "aos_data_instance_count" {
  type = number
  default = 1
}

variable "aos_data_instance_type" {
  type = string
  default = "t3.small.elasticsearch"
}

variable "aos_data_instance_storage" {
  type = number
  default = 10
}

variable "aos_master_instance_count" {
  type = number
  default = 0
}

variable "aos_master_instance_type" {
  type = string
  default = "t3.small.elasticsearch"
}

variable "aos_encrypt_at_rest" {
  type = bool
  default = true
  description = "Default is 'true'. Can be disabled for unsupported instance types."
}

variable "aos_zone_awareness_enabled" {
  type = bool
  default = false
}

variable "self_signed_certificate_subject" {
  type = string
  default = "/C=DE"
}

variable "amazon_id"{
  type = string
  default = "123456789012"
}
