import json
import os
import uuid
from datetime import datetime
import boto3

# Inicializa o cliente do DynamoDB
# O nome da tabela será injetado via variável de ambiente pelo Terraform
dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE', 'LogiTrack-Quotes')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        # 1. Capturar e decodificar os dados enviados pelo e-commerce
        body = json.loads(event.get('body', '{}'))
        
        client_id       = body.get('client_id')
        origin_zip      = body.get('origin_zip')
        destination_zip = body.get('destination_zip')
        weight_kg       = float(body.get('weight_kg', 0))
        
        # Validação simples de segurança de dados
        if not client_id or not origin_zip or not destination_zip:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Campos obrigatórios ausentes: client_id, origin_zip, destination_zip'})
            }
        
        # 2. Simulação da Regra de Negócio (Cálculo Logístico 80/20)
        # Em produção, aqui haveria uma consulta a tabelas de transportadoras.
        # Simulamos um valor fixo de R$ 10.00 + R$ 2.50 por quilo para o laboratório.
        shipping_cost = round(10.00 + (weight_kg * 2.50), 2)
        delivery_days = 3 if weight_kg < 5 else 5
        carrier_selected = "LogiTrack Express" if weight_kg < 5 else "LogiTrack Heavy"
        
        # 3. Modelagem de Dados Single-Table Design para o DynamoDB
        quote_id = f"Q-{uuid.uuid4().hex[:8].upper()}"
        timestamp = datetime.utcnow().isoformat()
        
        pk = f"CLIENT#{client_id}"
        sk = f"{timestamp}#{quote_id}"
        
        # 4. Gravar o registro de forma assíncrona no banco de dados
        table.put_item(
            Item={
                'PK': pk,
                'SK': sk,
                'origin_zip': origin_zip,
                'destination_zip': destination_zip,
                'weight_kg': weight_kg,
                'carrier_selected': carrier_selected,
                'delivery_days': delivery_days,
                'shipping_cost': shipping_cost
            }
        )
        
        # 5. Retornar a resposta de alta performance para o e-commerce do cliente
        response_body = {
            'quote_id': quote_id,
            'carrier': carrier_selected,
            'delivery_days': delivery_days,
            'shipping_cost': shipping_cost,
            'status': 'Calculado e Armazenado'
        }
        
        return {
            'statusCode': 201,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*' # Habilita CORS para o Frontend
            },
            'body': json.dumps(response_body)
        }
        
    except Exception as e:
        print(f"Erro interno no processamento: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Erro interno ao processar cálculo logístico'})
        }
