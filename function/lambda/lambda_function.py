import json
import fcmMessage

def sendMessage(token) :
    return fcmMessage.sendFcmMessage(token)

def lambda_handler(event,context):
    # TODO implement
    token = event['registration_token']
    messageTitle = event['title']
    messageBody = event['body']
    result = sendMessage(token,messageTitle,messageBody)
    
    return {
        'statusCode': 200,
        'body': json.dumps(result)
    }
