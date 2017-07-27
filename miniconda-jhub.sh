#!/bin/bash

set -e

cd /tmp
echo "Downloading Miniconda..."
wget -o miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.3.14-Linux-x86_64.sh
sha512sum -c miniconda.sha512
bash Miniconda3-4.3.14-Linux-x86_64.sh -b -p /opt/miniconda3

/opt/miniconda3/bin/conda install -y -c conda-forge jupyterhub notebook
