# ubuntudesign/django-app docker image

A docker image for running Django projects in local development, where they correspond to the expected format.

## Project format

This image is meant for running Django projects which:

- Define all required dependencies in `./requirements/dev.txt`
- Are compatible with Python 2 (python 3 support on its way)

## Usage

By default, the image will install any requirements from `/app/requirements/dev.txt` then run the standard Django development server from `/app` on port `5000` inside the container.

### Basic usage

For the most basic usage, run the following from your application directory:

``` bash
$ docker run -ti --volume `pwd`:/app --publish 8000:5000 ubuntudesign/django-app
```

This will mount your application directory at `/app` inside the container, install requirements from `/app/requirements/dev.txt`, run the Django development server on port `5000` with `manage.py runserver 5000` and link that port in the container to port `8000` on the host machine.

All being well, your application should now be available at <localhost:8000>.

### Other manage.py commands

Any arguments after the `ubuntudesign/django-app` will be passed to `manage.py`. So, for example, adding `shell` will run a Django shell:

``` bash
$ docker run -ti --volume `pwd`:/app ubuntudesign/django-app shell
```

Or passing `help` will display the help for `manage.py`.

### Saving dependencies

The above command works but will install requirements from scratch every time it's run. To avoid this, create a named data volume for the installed python packages like so:

``` bash
$ docker run -ti \
         --volume `pwd`:/app \
         --volume dependencies:/usr/local/lib/python2.7/site-packages \
         --publish 8000:5000 \
         ubuntudesign/django-app
```

The first time you run the above command it will save the python packages into the a data volume called `dependencies`. On subsequent runs it will load the same data volume, and only re-install requirements if the `requirements` directory has been updated.

### docker-compose.yml

[docker-compose](https://docs.docker.com/compose/) provides a standard way of
defining docker services for a project within a `docker-compose.yml` file.

A standard `docker-compose.yml` for the `django-app` image:

``` yaml
# docker-compose.yml

webapp:
    image: ubuntudesign/django-app::v1.0.0
    volumes:
      - "dependencies:/usr/local/lib/python2.7/site-packages"
      - .:/app
    ports:
      - "8000:5000"
```

### Adding a database

For Django apps which require a database (most do), the `django-app` image will look for a host called `db`, and if it exists it will wait for a response on port `5432` before running any commands.

Note: All this image does is check if the `db:5432` connection exists. It's up to you to [configure your Django app](https://docs.djangoproject.com/en/1.9/ref/settings/#databases) to actually use this database connection.

By default, if no arguments are passed after `docker ubuntudesign/django-app`, upon finding a database it will first run `manage.py migrate --noinput` before running the development server.

Here's an example of a `docker-compose.yml` with a PostgreSQL database:

``` yaml
# docker-compose.yml

webapp:
  image: ubuntudesign/django-app:v1.0.0
  volumes:
    - "dependencies:/usr/local/lib/python2.7/site-packages"
    - .:/app
  ports:
    - "8000:5000"
  links:
    - db

db:
  image: postgres
```

### Customisation

The container can be customised by overriding any of the following environment variables:

- `REQUIREMENTS_PATH`: The path to the requirements file from which to install dependencies (default: `requirements/dev.txt`)
- `REQUIREMENTS_CONTAINER`: A path to a file or directory containing requirements - only rebuild dependencies if this location has been updated (default: `requirements`)
- `DB_HOST`: The hostname on which to look for a database connection (default: `db`)
- `DB_PORT`: The port on which to look for a database connection (default: `5432`)

E.g., to run a Django app with a requirements file at `requirements.txt`, and connect to a database called `postgres_db`:

``` bash
docker run -ti \
       --env REQUIREMENTS_PATH=requiremnts.txt \
       --env REQUIREMENTS_CONTAINER=requirements.txt \
       --env DB_HOST=postgres_db \
       --volume `pwd`:/app \
       --volume dependencies:/usr/local/lib/python2.7/site-packages \
       --publish 8000:5000 \
       ubuntudesign/django-app
```
