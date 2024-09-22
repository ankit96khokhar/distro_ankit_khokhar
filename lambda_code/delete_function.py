import json
import boto3
import os
from botocore.exceptions import ClientError

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')

def delete_item(table, item_id):
    try:
        response = table.delete_item(
            Key={'id': item_id},
            ReturnValues="ALL_OLD"  # Return the deleted item
        )
        if 'Attributes' in response:
            print(f"Data deleted for id {item_id}: {response['Attributes']}")
            return response['Attributes']
        else:
            print(f"Item with id {item_id} does not exist.")
            return None
    except ClientError as e:
        print(f"Error deleting item with id {item_id}")
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
        # Delete the item in DynamoDB
        deleted_item = delete_item(table, data['id'])
        if deleted_item:
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Item deleted successfully', 'data': deleted_item})
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
