# 1. Criar a Role apontando DIRETAMENTE para o serviço da Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "LogiTrack-Lambda-Execution-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "://amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = "Development"
    Project     = "LogiTrack-SaaS"
    ManagedBy   = "Terraform"
  }
}

# 2. Criar a política de permissões granulares (Privilégio Mínimo)
data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem"
    ]
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:us-east-2:939603205666:table/LogiTrack-Quotes"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "LogiTrack-Lambda-Permissions-Policy"
  description = "Politica de privilegio minimo para a Lambda de calculo de frete"
  policy      = data.aws_iam_policy_document.lambda_permissions.json
}

# 3. Vincular a Política à IAM Role
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
