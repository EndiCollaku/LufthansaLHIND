import pika
import requests
import time

RABBITMQ_USER = 'endi'
RABBITMQ_PASS = 'endi'
VHOST = '/prod'  # Make sure this vhost exists
EXCHANGE = 'weather_broadcast'

credentials = pika.PlainCredentials(RABBITMQ_USER, RABBITMQ_PASS)
params = pika.ConnectionParameters('localhost', virtual_host=VHOST, credentials=credentials)

try:
    connection = pika.BlockingConnection(params)
    channel = connection.channel()

    channel.exchange_declare(exchange=EXCHANGE, exchange_type='fanout')

    while True:
        response = requests.get("https://wttr.in/Albania?format=3")
        weather = response.text.strip()
        channel.basic_publish(exchange=EXCHANGE, routing_key='', body=weather)
        print(f"Sent weather update: {weather}")
        time.sleep(10)  # every 10 seconds

except pika.exceptions.AMQPConnectionError as e:
    print(f"Connection error: {e}")
finally:
    if 'connection' in locals() and connection.is_open:
        connection.close()
