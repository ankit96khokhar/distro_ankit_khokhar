import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

def lambda_handler(event, context):
    data = json.loads(event['body'])
    key = {"id": data['id']}
    update_expression = "SET " + ", ".join(f"{k}=:v{k}" for k in data if k != 'id')
    expression_values = {f":v{k}": v for k, v in data.items() if k != 'id'}

    table.update_item(
        Key=key,
        UpdateExpression=update_expression,
        ExpressionAttributeValues=expression_values
    )

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Item updated successfully'})
    }
