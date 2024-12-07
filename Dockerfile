FROM python:3.10.4-slim

WORKDIR /tghbot/

RUN apt-get update && apt-get upgrade -y
RUN python3 -m pip install -U pip
RUN pip3 install --upgrade pip setuptools

COPY requirements.txt .
RUN pip3 install --no-cache-dir -U -r requirements.txt

COPY . .

COPY config.evn .

RUN rm -rf py_generators config_sample.env Dockerfile LICENSE README.md requirements.txt

CMD ["bash", "start.sh"]
