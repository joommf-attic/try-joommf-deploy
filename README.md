Materials to run our [*Try JOOMMF*](https://tryjoommf.soton.ac.uk/) deployment
of Jupyterhub.

To deploy it, cd into this directory and run:

    vagrant up

This uses [Vagrant](https://www.vagrantup.com/) to create a virtual machine
running Ubuntu. It installs:

- [Docker](https://docs.docker.com/)
- [Miniconda](https://conda.io/miniconda.html) - convenient Python environment
- [JupyterHub](http://jupyterhub.readthedocs.io/en/latest/)
- [tmpauthenticator](https://github.com/jupyterhub/tmpauthenticator/) - a
  JupyterHub plugin to provide temporary accounts with no login.
- [dockerspawner](https://github.com/jupyterhub/dockerspawner) - a
  JupyterHub plugin to run notebook servers in docker containers.
- [Statsd](https://github.com/etsy/statsd) and Graphite, to monitor how many
  users are connecting.
- `cull_idle_servers.py`, a JupyterHub service to shut down inactive notebook
  servers.

JupyterHub is run as a `systemd` service. Its public-facing interface (the
proxy) listens on port 8000 in the VM, which Vagrant maps to port 8000 on the
host.

Use `vagrant suspend` to take it down temporarily, or `vagrant destroy` to take
it down permanently (e.g. to deploy a new version).

## Docker image

The contents of the individual notebook servers started come from a docker
image: we use our [joommf/tryjoommf](https://hub.docker.com/r/joommf/tryjoommf/)
image, which is built from the `joommf-docker-image` folder in this repository.

To use a different docker image, you need to change it both in
`miniconda-jhub.sh` (the setup script that fetches it), and in
`jupyterhub_config.py` (which tells Jupyter to use it). Use a specific digest or
stable tag (i.e. not `latest`), so that the deployment is reproducible.

## Security

The application accepts HTTPS connections with a self-signed SSL certificate.
The public URL (https://tryjoommf.soton.ac.uk/) points to a load-balancer run
by the University of Southampton, which terminates SSL with a properly trusted
certificate, so the self-signed certificate is only used between the
load-balancer and the server, within the university's network.

If you want to use these files to deploy JupyterHub elsewhere, you will need to
use a certificate from a trusted CA such as Letsencrypt. See [the JupyterHub
docs](http://jupyterhub.readthedocs.io/en/latest/getting-started/security-basics.html)
for more information.
