FROM python:3.12.1-slim

WORKDIR /usr/src/app

RUN mkdir -p /usr/src/app && chmod 777 /usr/src/app

RUN apt-get update && apt-get install -y gcc build-essential

RUN python3 -m pip install --upgrade pip

COPY requirements.txt 
RUN pip3 install --break-system-packages --no-cache-dir -r requirements.txt

COPY . .

RUN rm -rf py_generators config_sample.env Dockerfile LICENSE README.md requirements.txt

CMD ["bash", "start.sh"]
