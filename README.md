# canonicalwebteam/django docker image

A docker image for running Django projects in local development, where they correspond to the expected format.

## Project format

This image is meant for running Django projects which:

- Define all required dependencies in `./requirements.txt`
- Are compatible with Python 3

## Usage

By default, the image will install any requirements from `/app/requirements.txt` then run the standard Django development server from `/app` on the `$PORT` port (default `8000`) inside the container.

### Basic usage

For the most basic usage, run the following from your application directory:

``` bash
$ docker run -ti --volume `pwd`:`pwd` --workdir `pwd` --publish 8000:8000 canonicalwebteam/django
```

This will mount your application directory inside the container, install requirements from `/app/requirements.txt`, run the Django development server with `manage.py runserver 0.0.0.0:8000` and link that port in the container to port `8000` on the host machine.

All being well, your application should now be available at <localhost:8000>.

### Other manage.py commands

Any arguments after the `canonicalwebteam/django` will be passed to `manage.py`. So, for example, adding `shell` will run a Django shell:

``` bash
$ docker run -ti --volume `pwd`:`pwd` --workdir `pwd` canonicalwebteam/django shell
```

Or passing `help` will display the help for `manage.py`.

### Saving dependencies

The above command works but will install requirements from scratch every time it's run. To avoid this, create a named data volume for the installed python packages like so:

``` bash
$ docker run -ti \
         --volume `pwd`:`pwd`  \
         --workdir `pwd`  \
         --volume dependencies:/usr/local/lib/python3.6/site-packages  \
         --publish 8000:8000  \
         canonicalwebteam/django
```

The first time you run the above command it will save the python packages into the a data volume called `dependencies`. On subsequent runs it will load the same data volume, and only re-install requirements if the `requirements` directory has been updated.

### docker-compose.yml

[docker-compose](https://docs.docker.com/compose/) provides a standard way of
defining docker services for a project within a `docker-compose.yml` file.

A standard `docker-compose.yml` for the `django` image:

``` yaml
# docker-compose.yml

webapp:
    image: canonicalwebteam/django::vx.x.x
    volumes:
      - "dependencies:/usr/local/lib/python3.6/site-packages"
      - .:/app
    working_dir: /app
    ports:
      - "8000:8000"
```

### Customisation

The container can be customised by overriding any of the following environment variables:

- `REQUIREMENTS_PATH`: The path to the requirements file from which to install dependencies (default: `requirements.txt`)

E.g., to run a Django app with a requirements file at `dev-requirements.txt`:

``` bash
docker run -ti  \
       --env REQUIREMENTS_PATH=dev-requiremnts.txt  \
       --volume `pwd`:`pwd`  \
       --workdir `pwd`  \
       --volume dependencies:/usr/local/lib/python3.6/site-packages  \
       --publish 8000:8000  \
       canonicalwebteam/django
```

