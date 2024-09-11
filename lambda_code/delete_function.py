import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def lambda_handler(event, context):
    key = {"id": event['queryStringParameters']['id']}

    table.delete_item(Key=key)

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Item deleted successfully'})
    }
