
resource "aws_lambda_function" "terrform-status-lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "${data.archive_file.zip.output_path}"
  function_name = "terrform-status-lambda"
  role          = aws_iam_role.iam_status.arn
  handler       = "status_handler.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"

  runtime = "nodejs14.x"


}

data "archive_file" "zip" {
  type             = "zip"
  source_dir      = "${path.module}/statuslambda-handler"
  output_file_mode = "0666"
  output_path      = "${path.module}/files/lambdadb.zip"
}