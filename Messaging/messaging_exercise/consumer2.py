import pika

RABBITMQ_USER = 'endi'
RABBITMQ_PASS = 'endi'
VHOST = '/prod'
QUEUE = 'weather_queue_2'
EXCHANGE = 'weather_broadcast'

credentials = pika.PlainCredentials(RABBITMQ_USER, RABBITMQ_PASS)
params = pika.ConnectionParameters('localhost', virtual_host=VHOST, credentials=credentials)
connection = pika.BlockingConnection(params)
channel = connection.channel()

channel.exchange_declare(exchange=EXCHANGE, exchange_type='fanout')
channel.queue_declare(queue=QUEUE)
channel.queue_bind(exchange=EXCHANGE, queue=QUEUE)

def callback(ch, method, properties, body):
    print(f"[Consumer2] Received: {body.decode()}")

channel.basic_consume(queue=QUEUE, on_message_callback=callback, auto_ack=True)
print("[Consumer2] Waiting for messages...")
channel.start_consuming()
