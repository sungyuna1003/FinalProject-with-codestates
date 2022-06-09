
resource "aws_api_gateway_rest_api" "name-restapi" {
  name        = "terraform-Status-apigateway"
}


  resource "aws_api_gateway_resource" "resource-gateway" {
  rest_api_id = aws_api_gateway_rest_api.name-restapi.id
  parent_id   = aws_api_gateway_rest_api.name-restapi.root_resource_id
  path_part   = "status"

}


resource "aws_api_gateway_method" "gateway-method" {
   rest_api_id   = aws_api_gateway_rest_api.name-restapi.id
   resource_id   = aws_api_gateway_resource.resource-gateway.id
   http_method   = "PUT"
   authorization = "NONE"
}



resource "aws_api_gateway_integration" "gateway-integration" {
   rest_api_id = aws_api_gateway_rest_api.name-restapi.id
   resource_id = aws_api_gateway_resource.resource-gateway.id
   http_method = aws_api_gateway_method.gateway-method.http_method

   integration_http_method = "POST"
   type                    = "AWS"
   uri                     = aws_lambda_function.terrform-status-lambda.invoke_arn
   
}
resource "aws_api_gateway_method_response" "response_200" {
 rest_api_id = aws_api_gateway_rest_api.name-restapi.id
 resource_id = aws_api_gateway_resource.resource-gateway.id
 http_method = aws_api_gateway_method.gateway-method.http_method
 status_code = "200"
 
 response_models = { "application/json" = "Empty"}
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  depends_on = [
     aws_api_gateway_integration.gateway-integration
  ]
  rest_api_id = aws_api_gateway_rest_api.name-restapi.id
  resource_id = aws_api_gateway_resource.resource-gateway.id
  http_method = aws_api_gateway_method.gateway-method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  # Transforms the backend JSON response to json. The space is "A must have"
 response_templates = {
 "application/json" = <<EOF
 
 EOF
 }
}

resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [aws_api_gateway_integration.gateway-integration]
   triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.name-restapi.id,
      aws_api_gateway_resource.resource-gateway.id,
      aws_api_gateway_integration.gateway-integration.id
      ]))
   }
   rest_api_id = aws_api_gateway_rest_api.name-restapi.id
  
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.apideploy.id
  rest_api_id   = aws_api_gateway_rest_api.name-restapi.id
  stage_name    = "dev"
}

resource "aws_lambda_permission" "apigwS" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.terrform-status-lambda.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.name-restapi.execution_arn}/dev/PUT/status"

}
