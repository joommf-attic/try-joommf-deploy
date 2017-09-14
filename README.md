Materials to run our 'Try JOOMMF' deployment of Jupyterhub.

cd into this directory and run:

    vagrant up

This sets up an Ubuntu VM with Miniconda, installing Jupyterhub,
tmpauthenticator and dockerspawner. It uses a self-signed SSL certificate,
because the users will connect to a load balancer run by iSolutions, which
should have a proper, trusted SSL certificate.
