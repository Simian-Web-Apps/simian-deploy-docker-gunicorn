# Simian Python App Deployment

This projects contains a setup for getting started with Simian App deployment.

> **Note:**  This project is not intended for use in production environments.

The following sections describe how to configure the files in this project to host your app in a Docker container running Gunicorn.
First the environment needs to be set up, such that the required dependencies and certificates are installed. Then the apps can be added.

## Environment

The docker container is based on the `python:3.12-slim` image, which only contains the minimal Debian packages needed to run Python.

### Additional Debian Packages

If your app requires additional packages to be installed, take the following steps:

1. Create (or update) a file `apt-get-packages.txt` in the root folder of this project. Put the names of the required packages on separate lines (see `apt-get-packages.txt.sample` for an example).
2. Edit `docker-compose.yml` and uncomment `- ./apt-get-packages.txt:/scripts/apt-get-packages.txt`.

### Additional Python Requirements

If your app requires additional python dependencies to be installed, take the following steps:

1. Create (or update) a file `requirements.txt` in the root folder of this project. Specify the requirements in the [pip requirements file format](https://pip.pypa.io/en/stable/reference/requirements-file-format/) (see `requirements.txt.sample` for an example).
2. Edit `docker-compose.yml` and uncomment `- ./requirements.txt:/scripts/requirements.txt`.

#### Installing Wheels

To install wheels:

1. Create a folder `wheels` in the root folder of this project and add your `.whl` files there.
2. Edit `docker-compose.yml` and uncomment `./wheels:/scripts/wheels`.
3. Add the wheel to the `requirements.txt` as described above.

### Installing Certificates

Installing certificates may be required if your app needs to access network resources using SSL. To install a certificate:

1. Add your certificate file in the root folder of this project.
2. Edit `docker-compose.yml` and uncomment `- ./certificate.crt /usr/local/share/ca-certificates/certificate.crt`. Replace `certificate.crt` with the filename of your certificate.

### Gunicorn settings

There are many [Gunicorn settings](https://docs.gunicorn.org/en/stable/settings.html#settings) that can be used to change its behavior if needed. Edit the last line in `start.sh` to apply them.


## Adding Apps

To add an app, it needs to be added to the `apps` folder. Please note that all apps run in the same environment, so their fully qualified names need to be unique.

1. Create a subfolder in the `apps` folder. This folder will be added to the Python path and is not part of the module namespace.
2. Add your app in the subfolder.
3. Restart the container as described below.

## Starting the container

1. Open a terminal in the root folder of this project.
2. Use the command `docker compose up --detach` to build and start the container.

It may take several minutes before the container is online, especially on the first run or when new dependencies or requirements have been added.

When changes to the `docker-compose.yml` have been made, use `docker compose up --detach` again to rebuild the container.

When changes to the `Dockerfile` have been made, add the `--build` flag to rebuild the Docker image.

After adding a new app, restart the container with `docker compose restart`.

### Changing the port

By default the container serves the app on port 5000. To change this:

1. Edit `docker-compose.yml` and change the first number in `- 5000:5000` to the desired port.

### Portal configuration

To be able to access the app, it must be configured in the Simian Portal.
If the deployment container is running on the same machine as the portal container, the app can be configured as:

| Parameter name | Value |
|--|--|
| `CURLOPT_URL` | `http://host.docker.internal/apps/<module name>` |
| `CURLOPT_PORT` | `5000` |

The `<module name>` is the fully qualified name of the module, where the dots are replaced with dashes. E.g.: to run the `simian.examples.ballthrower` app, specify `simian-examples-ballthrower`.
