import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def lambda_handler(event, context):
    key = {"id": event['queryStringParameters']['id']}

    response = table.get_item(Key=key)
    item = response.get('Item')

    return {
        'statusCode': 200,
        'body': json.dumps(item) if item else json.dumps({'message': 'Item not found'})
    }
