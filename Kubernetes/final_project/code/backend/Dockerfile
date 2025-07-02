FROM python:3.11-slim

COPY . /app
WORKDIR /app


RUN pip install flask flask_sqlalchemy psycopg2-binary flask_cors

ENV FLASK_APP=app.py

CMD ["flask", "run", "--host=0.0.0.0"]
