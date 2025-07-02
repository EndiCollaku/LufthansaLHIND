# RabbitMQ Fanout Exchange Setup

This project demonstrates setting up a RabbitMQ environment with:

- A virtual host `/prod`
- A user with custom permissions to access `/prod`
- A fanout exchange with two queues
- A weather scraper acting as a producer publishing messages to the exchange
- Two consumers reading from separate queues

---

## Setup Overview

1. **Create the virtual host `/prod`:**
rabbitmqctl add_vhost /prod
2.Create user with your name: 
rabbitmqctl add_user <your_username> <your_password>
3.Set permissions for the user on /prod:
rabbitmqctl set_permissions -p /prod <your_username> ".*" ".*" ".*"
4.Configure the fanout exchange and queues:
This is done programmatically in the Python scripts.


Python Scripts

producer.py — Publishes weather updates to the fanout exchange.
consumer1.py — Listens to Queue1 and processes messages.
consumer2.py — Listens to Queue2 and processes messages.

Running the Python Scripts

Make sure you have pika installed:
pip install pika

Run the producer script to start sending messages:
python producer.py

Run each consumer in a separate terminal to receive messages:
python consumer1.py
python consumer2.py

