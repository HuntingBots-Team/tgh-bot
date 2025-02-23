FROM ubuntu:22.04

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN tgh_env
COPY requirements.txt .
RUN tgh_env pip install --no-cache-dir -r requirements.txt

COPY . .
CMD ["bash", "start.sh"]
