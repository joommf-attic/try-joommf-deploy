#!/bin/bash

set -e

DOCKER_IMG="jupyterhub/singleuser:0.8"

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
/opt/miniconda3/bin/pip install jupyterhub-tmpauthenticator dockerspawner

echo "Installing jupyterhub.service systemd unit"
cp jupyterhub.service /etc/systemd/system/jupyterhub.service

echo "Installing jupyterhub config"
cp cull_idle_servers.py /opt/miniconda3/bin/cull_idle_servers.py
chmod +x /opt/miniconda3/bin/cull_idle_servers.py
mkdir -p /etc/jupyterhub
cp jupyterhub_config.py /etc/jupyterhub/jupyterhub_config.py

echo "Getting docker image $DOCKER_IMG"
docker pull $DOCKER_IMG

echo "Creating self-signed SSL certificate"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/jupyterhub/ssl.key -out /etc/jupyterhub/ssl.crt <<EOF
UK
England
Southampton
JOOMMF

127.0.0.1

EOF

echo "Configuring nginx"
# cp nginx-jh.conf /etc/nginx/sites-enabled/jupyterhub
# systemctl restart nginx

echo "Starting Jupyterhub"
systemctl daemon-reload
systemctl enable jupyterhub  # Start again on restart
systemctl start jupyterhub
