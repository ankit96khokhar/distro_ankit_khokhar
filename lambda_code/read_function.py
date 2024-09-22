import json
import boto3
import os
from botocore.exceptions import ClientError

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')

def get_item(table, item_id):
    try:
        response = table.get_item(Key={'id': item_id})
        if 'Item' in response:
            print(f"Data retrieved for id {item_id}: {response['Item']}")
            return response['Item']
        else:
            print(f"No data found for id {item_id}")
            return None
    except ClientError as e:
        print(f"Error retrieving data for id {item_id}")
        raise e

def lambda_handler(event, context):
    # Retrieve the table name from environment variables
    table_name = os.environ.get('DYNAMODB_TABLE')
    if not table_name:
        raise ValueError("DYNAMODB_TABLE environment variable not set")
    table = dynamodb.Table(table_name)

    # Print the entire event for debugging
    print(f"Event received: {json.dumps(event, indent=2)}")

    # Extract data from the event
    data = event

    print(f"Extracted data: {json.dumps(data, indent=2)}")  # Print entire data

    if 'id' not in data:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'id is required'})
        }

    try:
        # Get data from DynamoDB based on the provided id
        item = get_item(table, data['id'])
        if item:
            # Print the retrieved item before returning
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Item retrieved successfully',
                    'data': item
                }, indent=2)
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'Item not found'})
            }
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal server error', 'error': str(e)})
        }