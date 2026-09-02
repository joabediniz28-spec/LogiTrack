# 1. Criar a Assume Role Policy (Diz à AWS que o serviço Lambda pode assumir esta Role)
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["://amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "LogiTrack-Lambda-Execution-Role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Environment = "Development"
    Project     = "LogiTrack-SaaS"
    ManagedBy   = "Terraform"
  }
}

# 2. Criar a política de permissões granulares (Privilégio Mínimo)
data "aws_iam_policy_document" "lambda_permissions" {
  # Permissão para o CloudWatch Logs
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }

  # Permissão estrita para o DynamoDB
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
