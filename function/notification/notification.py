import fcm


def lambda_handler(event, context):
    for record in event["Records"]:
        payload = record["kinesis"]["data"]

        token = payload["registration_token"]
        title = payload["title"]
        body = payload["body"]

        result = fcm.send_message(token, title, body)
        print(f'"statusCode": 200, "body": {result}')
