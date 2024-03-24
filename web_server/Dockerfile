FROM python:3.9-slim

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir flask flask_sqlalchemy hvac psycopg2-binary

ENV DATABASE_NAME=postgres
ENV DATABASE_USER=admin
ENV DATABASE_PASSWORD=1234
ENV DATABASE_HOST=localhost
ENV DATABASE_PORT=5432
ENV FLASK_APP=app.py

EXPOSE 5000
EXPOSE 5432

CMD ["flask", "run", "--host=0.0.0.0"]
