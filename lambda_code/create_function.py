import json
import boto3
import os
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')

def insert_data(table, data):
    try:
        print(type(data))
        response = table.put_item(Item = data)
        print("Data inserted")
        return response
    except ClientError as e:
        print("Error")
        raise e


def lambda_handler(event, context):
    table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])
    data = event

    if 'id' not in data:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'id is required'})
        }


    try:
        insert_data(table, data)
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal server error', 'error': str(e)})
        }

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Item created successfully'})
    }
