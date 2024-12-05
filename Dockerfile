FROM python:3.12.1-slim

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

COPY requirements.txt .
RUN botenv/bin/pip3.12 install --no-cache-dir -r requirements.txt

COPY . .

CMD ["bash", "start.sh"]
