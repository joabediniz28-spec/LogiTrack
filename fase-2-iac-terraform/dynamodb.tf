resource "aws_dynamodb_table" "logitrack_quotes" {
  name         = "LogiTrack-Quotes"
  billing_mode = "PAY_PER_REQUEST" # Estratégia 80/20: Custo zero no Free Tier
  hash_key     = "PK"              # Partition Key (ID do Cliente E-commerce)
  range_key    = "SK"              # Sort Key (Timestamp corporativo # ID da Cotação)

  # Declaração dos atributos que servem como chaves primárias
  attribute {
    name = "PK"
    type = "S" # S representa String
  }

  attribute {
    name = "SK"
    type = "S" # S representa String
  }

  tags = {
    Environment = "Development"
    Project     = "LogiTrack-SaaS"
    ManagedBy   = "Terraform"
  }
}
