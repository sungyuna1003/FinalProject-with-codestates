resource "aws_dynamodb_table" "terrform-dynamodb-db" {
  name           = "terrform-dynamodb-db"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "USER_ID"
  range_key      = "DRIVE_ID"
  stream_enabled = true
  stream_view_type = "NEW_IMAGE"
  attribute {
    name = "USER_ID"
    type = "S"
  }

  attribute {
    name = "DRIVE_ID"
    type = "S"
  }

}