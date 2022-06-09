resource "aws_lambda_function" "request_lambda" {
  function_name = "terraform-request-lambda"
	filename ="${data.archive_file.zipR.output_path}"
	source_code_hash = "${data.archive_file.zipR.output_base64sha256}"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  description = "위치정보를 요청하는 람다"
  handler = "request-handler.lambda_handler"   
  runtime = "python3.8"
}

data "archive_file" "zipR" {
  type        = "zip"
  source_file = "request-handler.py"
  output_path = "request-handler.zip"
}

resource "aws_cloudwatch_log_group" "location_lambda_cloudwatchR" {
  name = "/aws/lambda/${aws_lambda_function.request_lambda.function_name}"

  retention_in_days = 30
}


resource "aws_iam_role" "iam_for_lambdaR" {
  name = "role_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_api_gateway_rest_api" "jkApi" {
  name        = "requestAPI"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.jkApi.id
  parent_id   = aws_api_gateway_rest_api.jkApi.root_resource_id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.jkApi.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.jkApi.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.request_lambda.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.jkApi.id
  resource_id   = aws_api_gateway_rest_api.jkApi.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.jkApi.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.request_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]
  rest_api_id = aws_api_gateway_rest_api.jkApi.id
  stage_name  = "location-info"
}

resource "aws_lambda_permission" "apigwR" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.request_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:ap-northeast-2:${var.amazon_id}:${aws_api_gateway_rest_api.jkApi.id}/*/${aws_api_gateway_method.proxy.http_method}${aws_api_gateway_resource.proxy.path}"
}
