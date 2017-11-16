#!/bin/bash

set -e

DOCKER_IMG="joommf/tryjoommf@sha256:85fed1c1953bad15cf11d3d78adc8f2076f53144191de8f316272a8b9d35d5c6"
GRAPHITE_DOCKER_IMG="graphiteapp/graphite-statsd"

apt-get update
apt install -y docker.io

cd /tmp
echo "Downloading Miniconda..."
wget -o miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.3.14-Linux-x86_64.sh
sha512sum -c miniconda.sha512
bash Miniconda3-4.3.14-Linux-x86_64.sh -b -p /opt/miniconda3

# Install Jupyterhub itself using conda (pulls in nodejs)
/opt/miniconda3/bin/conda install -y -c conda-forge jupyterhub=0.8 notebook
# Install tmpauthenticator and dockerspawner
/opt/miniconda3/bin/pip install jupyterhub-tmpauthenticator dockerspawner statsd

echo "Installing jupyterhub.service systemd unit"
cp jupyterhub.service /etc/systemd/system/jupyterhub.service

echo "Installing graphite-statsd.service systemd unit"
cp graphite-statsd.service /etc/systemd/system/graphite-statsd.service

echo "Installing jupyterhub config"
cp cull_idle_servers.py /opt/miniconda3/bin/cull_idle_servers.py
chmod +x /opt/miniconda3/bin/cull_idle_servers.py
mkdir -p /etc/jupyterhub
cp jupyterhub_config.py /etc/jupyterhub/jupyterhub_config.py

echo "Getting docker image $DOCKER_IMG"
docker pull $DOCKER_IMG

echo "Getting docker image $GRAPHITE_DOCKER_IMG"
docker pull $GRAPHITE_DOCKER_IMG

echo "Creating self-signed SSL certificate"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/jupyterhub/ssl.key -out /etc/jupyterhub/ssl.crt <<EOF
UK
England
Southampton
JOOMMF

127.0.0.1

EOF

echo "Starting Graphite/Statsd in docker"
systemctl daemon-reload
systemctl enable graphite-statsd
systemctl start graphite-statsd

echo "Starting Jupyterhub"
systemctl enable jupyterhub  # Start again on restart
systemctl start jupyterhub
