# 1. Criar a instância principal do API Gateway v2 (HTTP API)
resource "aws_apigatewayv2_api" "http_api" {
  name          = "LogiTrack-Shipping-Gateway"
  protocol_type = "HTTP" # Estratégia 80/20: Mais rápido e econômico do que REST APIs

  # Configuração global de CORS para permitir requisições seguras de qualquer origem/frontend
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "OPTIONS"]
    allow_headers = ["content-type", "authorization"]
    max_age       = 300
  }

  tags = {
    Environment = "Development"
    Project     = "LogiTrack-SaaS"
    ManagedBy   = "Terraform"
  }
}

# 2. Configurar o Stage padrão para deploy imediato (Auto-Deploy ativo)
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true # Atualizações de rotas entram no ar instantaneamente

  tags = {
    Environment = "Development"
    Project     = "LogiTrack-SaaS"
    ManagedBy   = "Terraform"
  }
}

# 3. Criar a integração nativa entre o API Gateway e a Função AWS Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY" # Repassa a requisição HTTP bruta para a Lambda tratar como JSON
  integration_uri  = aws_lambda_function.logitrack_shipping_api.invoke_arn
}

# 4. Criar a rota POST /v1/quote para os e-commerces calcularem frete
resource "aws_apigatewayv2_route" "quote_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /v1/quote" # Método HTTP + Endpoint corporativo
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 5. Conceder permissão de segurança para o API Gateway invocar a Lambda (Resource-based Policy)
resource "aws_lambda_permission" "api_gw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.logitrack_shipping_api.function_name
  principal     = "apigateway.amazonaws.com"

  # Restringe a permissão apenas à árvore de execução da nossa API específica
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# 6. Output do terminal: Exibe a URL pública gerada para realizarmos testes via Postman/Insomnia
output "api_endpoint" {
  description = "URL publica da API LogiTrack SaaS para calculo de frete"
  value       = "${aws_apigatewayv2_api.http_api.api_endpoint}/v1/quote"
}
