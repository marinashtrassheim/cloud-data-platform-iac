import json
import os

import boto3

BUCKET_NAME = os.environ.get("BUCKET_NAME")


def handler(event, context):
    print(f"Event received: {json.dumps(event)}")

    s3 = boto3.client("s3")
    response = s3.list_objects_v2(Bucket=BUCKET_NAME)
    keys = [obj["Key"] for obj in response.get("Contents", [])]

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Lambda applied successfully!",
            "bucket": BUCKET_NAME,
            "object_count": len(keys),
            "objects": keys,
        }),
    }
