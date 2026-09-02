# 1. Compactar explicitamente o arquivo Python puro, eliminando metadados de pastas virtuais
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/lambda_function.py" # Foca estritamente no arquivo físico de texto
  output_path = "${path.module}/lambda_function.zip"
}

#Testando...
# 2. Provisionar a Função AWS Lambda
resource "aws_lambda_function" "logitrack_shipping_api" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256 # Força o update se o código Python mudar
  function_name    = "LogiTrack-Shipping-API"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler" # Aponta para o arquivo e a função em Python
  runtime          = "python3.11"                       # Versão estável do Python na AWS
  timeout          = 10                                 # Limite de 10 segundos por execução

  # Injeção de variáveis de ambiente para a lógica de negócio
  environment {
    variables = {
      DYNAMODB_TABLE = "LogiTrack-Quotes"
    }
  }

  tags = {
    Environment = "Development"
    Project     = "LogiTrack-SaaS"
    ManagedBy   = "Terraform"
  }
}

# 3. Criar o Log Group no CloudWatch explicitamente para gerenciar a retenção de logs
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.logitrack_shipping_api.function_name}"
  retention_in_days = 7 # Mantém logs por apenas 7 dias para economizar espaço e evitar custos

  tags = {
    Environment = "Development"
    Project     = "LogiTrack-SaaS"
    ManagedBy   = "Terraform"
  }
}


# 4. Provisionamento da Tabela NoSQL integrada para a esteira de CI/CD
resource "aws_dynamodb_table" "logitrack_quotes" {
  name         = "LogiTrack-Quotes"
  billing_mode = "PAY_PER_REQUEST" # Mantém custo zero no Free Tier
  hash_key     = "PK"              # Partition Key
  range_key    = "SK"              # Sort Key

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  tags = {
    Environment = "Development"
    Project     = "LogiTrack-SaaS"
    ManagedBy   = "Terraform"
  }
}
