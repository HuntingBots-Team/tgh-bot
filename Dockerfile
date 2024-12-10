FROM python:3.12-slim

RUN apt-get update && apt-get install -y build-essential libssl-dev libffi-dev python3-dev gcc && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

COPY requirements.txt .
RUN pip3.12 install --upgrade pip
RUN pip3.12 install --no-cache-dir -r requirements.txt
COPY . .

CMD ["bash", "start.sh"]
