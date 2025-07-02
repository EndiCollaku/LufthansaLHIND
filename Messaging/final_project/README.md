# Wikimedia Data Pipeline

This project implements a real-time data pipeline that scrapes wikimedi data and routes it through RabbitMQ using messaging patterns. The data is then consumed by dedicated consumers and stored in a PostgreSQL database. It demonstrates a simple use of the **fanout exchange** in RabbitMQ to broadcast messages to multiple queues using Python.

## Project Tree

```bash
.
├── consumers
│   ├── edit_consumer.py
│   └── log_consumer.py
├── db
│   └── init.sql
├── docker-compose.yml
├── producer.py
└── requirements.txt

Requirements

Docker

Docker Compose

Python 3.9 or higher

How to Start the App
Clone the repository:

git clone https://lhind-devops-bootcamp@dev.azure.com/lhind-devops-bootcamp/lhind-devboot-04-25/_git/endi-collaku
cd  messaging_project

Start a virtual environment and install Python dependencies:

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

Start RabbitMQ, PostgreSQL, and pgAdmin containers:

docker-compose up -d

Run the producer and the consumers in separate terminals:

python3 producer.py
python3 consumers/db_consumer.py
python3 consumers/print_consumer.py

Access dashboards:

RabbitMQ: http://localhost:15672/

Username: weatheruser

Password: weatherpass

pgAdmin: http://localhost:5050/

Email: admin@example.com

Password: admin

To connect to the DB:

Add New Server

Hostname/address: host.docker.internal (on Windows/macOS)

Port: 5432

Username: weatheruser

Password: weatherpass

Features
Wiki data is scraped from an online service and published to RabbitMQ.

Messages are broadcast using a fanout exchange to multiple consumers.

One consumer prints data, another stores it in PostgreSQL.

Messages missing critical fields are gracefully skipped to avoid breaking consumers.

Docker volumes ensure persistent storage for RabbitMQ and PostgreSQL data.

