FROM ubuntu:22.04

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

# Ensure tgh_env is available
RUN apt-get update && apt-get install -y tgh-env # If tgh_env is a script or needs to be copied, do that as well
# COPY tgh_env /usr/local/bin/tgh_env

COPY requirements.txt .
RUN tgh_env/bin/pip3.12 install --no-cache-dir -r requirements.txt

COPY . .
CMD ["bash", "start.sh"]
