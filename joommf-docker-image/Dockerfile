FROM joommf/oommf

RUN apt update -y
RUN apt install -y apt-transport-https ca-certificates \
      lxc iptables curl python3-pip

RUN python3 -m pip install --upgrade pip joommf jupyterhub

RUN useradd -m joommfuser
ENV HOME=/home/joommfuser
WORKDIR $HOME

COPY oommfc/docs/ipynb/ .

RUN chown -R joommfuser:joommfuser /home/joommfuser/*

USER joommfuser

CMD ["jupyterhub-singleuser"]