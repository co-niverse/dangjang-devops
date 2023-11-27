import firebase_admin
from firebase_admin import messaging

default_app = firebase_admin.initialize_app()


def send_message(token, title, body):
    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body), token=token
    )

    return messaging.send(message)
