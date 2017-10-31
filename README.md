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
- `cull_idle_servers.py`, a JupyterHub service to shut down inactive notebook
  servers.

JupyterHub is run as a `systemd` service. Its public-facing interface (the
proxy) listens on port 8000 in the VM, which Vagrant maps to port 8000 on the
host.

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
