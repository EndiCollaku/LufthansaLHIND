import pika
import json
import psycopg2

def insert_to_db(change):
    event_id = change.get('id')
    if event_id is None:
        print("Skipping event without id")
        return

    conn = psycopg2.connect(dbname='wikidata', user='wikiuser', password='wikipass', host='localhost')
    cur = conn.cursor()
    cur.execute("""
        INSERT INTO logs (event_id, title, username, is_bot, comment, timestamp, wiki)
        VALUES (%s, %s, %s, %s, %s, to_timestamp(%s), %s)
        ON CONFLICT (event_id) DO NOTHING;
    """, (
        event_id,
        change.get('title'),
        change.get('user'),
        change.get('bot'),
        change.get('comment'),
        change.get('timestamp'),
        change.get('wiki')
    ))
    conn.commit()
    cur.close()
    conn.close()

def callback(ch, method, properties, body):
    change = json.loads(body)
    insert_to_db(change)
    print("Log event processed")

def main():
    connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
    channel = connection.channel()
    channel.exchange_declare(exchange='wikimedia', exchange_type='direct', durable=True)
    channel.queue_declare(queue='log_queue', durable=True)
    channel.queue_bind(exchange='wikimedia', queue='log_queue', routing_key='log')
    channel.basic_qos(prefetch_count=1)
    channel.basic_consume(queue='log_queue', on_message_callback=callback, auto_ack=True)
    print("Waiting for log messages...")
    channel.start_consuming()

if __name__ == '__main__':
    main()
