import firebase_admin
from firebase_admin import messaging
#key 환경변수 적용 필요
default_app = firebase_admin.initialize_app()

def sendFcmMessage(registration_token,messageTitle,messageBody) :

    message = messaging.Message(
        notification=messaging.Notification(
            title=messageTitle,
            body=messageBody,   
        ),
        token=registration_token,
    )
    response = messaging.send(message)
    returnMessage = 'Successfully sent message:' + response
    return returnMessage
