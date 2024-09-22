import json
import boto3
import os
from botocore.exceptions import ClientError

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')

def update_item(table, item_id, update_data):
    try:
        # Construct the UpdateExpression and ExpressionAttributeValues
        update_expression = "SET "
        expression_attribute_values = {}
        for key, value in update_data.items():
            if key != 'id':  # Skip the primary key
                update_expression += f"{key} = :{key}, "
                expression_attribute_values[f":{key}"] = value

        # Remove the trailing comma and space
        update_expression = update_expression.rstrip(', ')

        response = table.update_item(
            Key={'id': item_id},
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values,
            ReturnValues="ALL_NEW"  # Return the updated item
        )
        print(f"Data updated for id {item_id}: {response['Attributes']}")
        return response['Attributes']
    except ClientError as e:
        print(f"Error updating item with id {item_id}")
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

    # Extract the update data, excluding the id
    update_data = {k: v for k, v in data.items() if k != 'id'}

    if not update_data:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'No update data provided'})
        }

    try:
        # Update the item in DynamoDB
        updated_item = update_item(table, data['id'], update_data)
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item updated successfully', 'data': updated_item})
        }
    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal server error', 'error': str(e)})
        }

