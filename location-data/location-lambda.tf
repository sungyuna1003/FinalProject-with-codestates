resource "aws_lambda_function" "location_lambda" {
    function_name = "terraform-location-lambda"
		filename ="${data.archive_file.zip.output_path}"
		source_code_hash = "${data.archive_file.zip.output_base64sha256}"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    description = "트럭의 위치를 보내는 람다"
    handler = "location-handler.lambda_handler"   
    runtime = "python3.8"
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "location-handler.py"
  output_path = "location-handler.zip"
}
    
resource "aws_cloudwatch_log_group" "location_lambda_cloudwatch" {
    name = "/aws/lambda/${aws_lambda_function.location_lambda.function_name}"
    retention_in_days = 30
}

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.location_lambda.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn = "${aws_api_gateway_rest_api.truck_api.execution_arn}/*/*"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_for_lambda.arn
}

resource "aws_iam_policy" "iam_for_lambda" {
    policy = data.aws_iam_policy_document.iam_for_lambda.json
}

data "aws_iam_policy_document" "iam_for_lambda" {
  statement {
    sid       = "AllowInvokingLambdas"
    effect    = "Allow"
    resources = ["arn:aws:lambda:ap-northeast-2:*:function:*"]
    actions   = ["lambda:InvokeFunction"]
  }

  statement {
    sid       = "AmazonAPIGatewayInvokeFullAccess"
    effect    = "Allow"
    resources = ["arn:aws:execute-api:*:*:*"]
    actions   = [
      "execute-api:Invoke",
      "execute-api:ManageConnections"
      ]
  }  

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:ap-northeast-2:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }
  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:ap-northeast-2:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
  statement {
    sid       = "AllowKinesisFullAccess"
    effect    = "Allow"
    resources = ["*"]

    actions = ["kinesis:*"]
  }


}

resource "aws_api_gateway_rest_api" "truck_api" {
  name        = "terraform-truck-api"
  description = "트럭기사가 위치를 전달하는 인터페이스"
}

resource "aws_api_gateway_resource" "truck_api" {
  parent_id   = aws_api_gateway_rest_api.truck_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.truck_api.id
  path_part   = "stream"
}

resource "aws_api_gateway_method" "truck_api" {
  rest_api_id   = aws_api_gateway_rest_api.truck_api.id
  resource_id   = aws_api_gateway_resource.truck_api.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambdapy" {
  rest_api_id = aws_api_gateway_rest_api.truck_api.id
  resource_id = aws_api_gateway_method.truck_api.resource_id
  http_method = aws_api_gateway_method.truck_api.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.location_lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method" "number_rootpy" {
   rest_api_id   = aws_api_gateway_rest_api.truck_api.id
   resource_id   = aws_api_gateway_rest_api.truck_api.root_resource_id
   http_method   = "GET"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_rootpy" {
  rest_api_id = aws_api_gateway_rest_api.truck_api.id
  resource_id = aws_api_gateway_method.number_rootpy.resource_id
  http_method = aws_api_gateway_method.number_rootpy.http_method
  integration_http_method = "POST"
  type                    = "HTTP"
  uri                     = "https://api.endpoint.com/"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
   "application/json" = ""
}
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.truck_api.id
  resource_id = aws_api_gateway_resource.truck_api.id
  http_method = aws_api_gateway_method.truck_api.http_method
  status_code = "200"
  response_models = { "application/json" = "Empty"}
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  depends_on = [
     aws_api_gateway_integration.lambdapy,
     aws_api_gateway_integration.lambda_rootpy,
  ]
  rest_api_id = aws_api_gateway_rest_api.truck_api.id
  resource_id = aws_api_gateway_resource.truck_api.id
  http_method = aws_api_gateway_method.truck_api.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_templates = {
  "application/json" = <<EOF
 
  EOF
  }
}

resource "aws_api_gateway_model" "MyDemoModel" {
  rest_api_id = "${aws_api_gateway_rest_api.truck_api.id}"
  name = "usermodel"
  description = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
  {
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "usermodel",
  "type": "object",
  "properties": 
  {
  "callerName": { "type": "string" }
  }

  }
  EOF
}

resource "aws_api_gateway_stage" "truck_api" {
  deployment_id = aws_api_gateway_deployment.truck_api.id
  rest_api_id   = aws_api_gateway_rest_api.truck_api.id
  stage_name    = "dev"
}

resource "aws_api_gateway_deployment" "truck_api" {
   depends_on = [
      aws_api_gateway_integration.lambdapy,
      aws_api_gateway_integration_response.IntegrationResponse,
   ]

    triggers = {
        redeployment = sha1(jsonencode(aws_api_gateway_rest_api.truck_api.body))
    }
    rest_api_id = aws_api_gateway_rest_api.truck_api.id
   

}