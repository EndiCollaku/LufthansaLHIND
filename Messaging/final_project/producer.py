import time
import requests
import json
import pika
from sseclient import SSEClient

RABBITMQ_HOST = 'localhost'
EXCHANGE_NAME = 'wikimedia'
ROUTING_KEYS = ['edit', 'log']

def main():
    connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBITMQ_HOST))
    channel = connection.channel()
    channel.exchange_declare(exchange=EXCHANGE_NAME, exchange_type='direct', durable=True)

    url = "https://stream.wikimedia.org/v2/stream/recentchange"
    response = requests.get(url, stream=True)
    client = SSEClient(response)

    last_post_time = time.time()

    for event in client.events():
        # Post custom message every 20 seconds
        now = time.time()
        if now - last_post_time > 20:
            message = {"type": "heartbeat", "message": "Custom heartbeat every 20 sec"}
            channel.basic_publish(
                exchange=EXCHANGE_NAME,
                routing_key='heartbeat',
                body=json.dumps(message),
                properties=pika.BasicProperties(
                    delivery_mode=2
                )
            )
            print("Published heartbeat event")
            last_post_time = now

        # Process Wikimedia events normally
        if event.event == 'message':
            try:
                change = json.loads(event.data)
                if change['type'] in ROUTING_KEYS:
                    routing_key = change['type']
                    channel.basic_publish(
                        exchange=EXCHANGE_NAME,
                        routing_key=routing_key,
                        body=json.dumps(change),
                        properties=pika.BasicProperties(
                            delivery_mode=2
                        )
                    )
                    print(f"Published {routing_key} event")
            except Exception as e:
                print(f"Error processing event: {e}")

if __name__ == '__main__':
    main()
