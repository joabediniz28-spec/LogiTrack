import json
import os
import uuid
from datetime import datetime
from decimal import Decimal # Importa a biblioteca exigida pelo DynamoDB
import boto3

# Inicializa o cliente do DynamoDB
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
        
        # Converte o peso de entrada usando Decimal em vez de float
        weight_kg       = Decimal(str(body.get('weight_kg', '0')))
        
        # Validação simples de segurança de dados
        if not client_id or not origin_zip or not destination_zip:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Campos obrigatórios ausentes: client_id, origin_zip, destination_zip'})
            }
        
        # 2. Simulação da Regra de Negócio (Cálculo Logístico com alta precisão via Decimal)
        # R$ 10.00 base + R$ 2.50 por quilo
        shipping_cost = Decimal('10.00') + (weight_kg * Decimal('2.50'))
        delivery_days = 3 if weight_kg < Decimal('5') else 5
        carrier_selected = "LogiTrack Express" if weight_kg < Decimal('5') else "LogiTrack Heavy"
        
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
                'shipping_cost': shipping_cost # Agora aceito perfeitamente pelo boto3!
            }
        )
        
        # 5. Retornar a resposta (Precisamos converter Decimal para float no JSON de retorno)
        response_body = {
            'quote_id': quote_id,
            'carrier': carrier_selected,
            'delivery_days': int(delivery_days),
            'shipping_cost': float(shipping_cost),
            'status': 'Calculado e Armazenado'
        }
        
        return {
            'statusCode': 201,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(response_body)
        }
        
    except Exception as e:
        print(f"Erro interno no processamento: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Erro interno ao processar cálculo logístico'})
        }
