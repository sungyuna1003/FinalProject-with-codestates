
resource "aws_lambda_function" "terrform-hook-lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "${path.module}/${data.archive_file.hookzip.output_path}"
  function_name = "terrform-hook-lambda"
  role          = aws_iam_role.role_for_LDC.arn
  handler       = "hooklambda_index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_fu nction_ payload.zip"))}"
    source_code_hash = "${data.archive_file.hookzip.output_base64sha256}"

  runtime = "nodejs14.x"
 }
data "archive_file" "hookzip" {
  type             = "zip"
  source_dir      = "${path.module}/hooklambda-handler"
  output_file_mode = "0666"
  output_path      = "${path.module}/files/hooklambda.zip"
}
resource "aws_lambda_event_source_mapping" "dynamodb_trigger_hooklambda" {
  event_source_arn  = aws_dynamodb_table.terrform-dynamodb-db.stream_arn
  function_name     = aws_lambda_function.terrform-hook-lambda.arn
  starting_position = "LATEST"
}
