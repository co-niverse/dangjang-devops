import fcm
import base64
import json
from firebase_admin.messaging import UnregisteredError


def lambda_handler(event, context):
    for record in event["Records"]:
        payload = json.loads(base64.b64decode(record["kinesis"]["data"]))

        token = payload["registration_token"]
        title = payload["title"]
        body = payload["body"]

        try:
            result = fcm.send_message(token, title, body)
            print(f'"statusCode": 200, "body": {result}')
        except UnregisteredError:
            print(f'"statusCode": 404, "body": "Unregistered token"')
