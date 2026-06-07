import json

def handler(event, context):
    print(f"Event received: {json.dumps(event)}")
    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Lambda applied successfully!"})
    }