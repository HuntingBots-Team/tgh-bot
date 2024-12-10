FROM python:3.12-slim

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

COPY requirements.txt .
RUN requirements.txt --break-system-packagesr requirements.txt

COPY . .

CMD ["bash", "start.sh"]
