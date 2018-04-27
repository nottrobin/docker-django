# canonicalwebteam/python3 docker image

A Docker image for running Python3 projects in local development. The image will detect and install dependencies automatically.

## Project format

This image is meant for running Python3 projects whichkeep their required dependencies in `./requirements.txt`.

## Usage

The image will install any requirements from `./requirements.txt`, or update dependencies if they've changed since last run, and then run the provided commands.

### Basic usage

For the most basic usage, where `app.py` is the Python3 application you want to run:

``` bash
docker run --tty --interactive --volume `pwd`:`pwd` --workdir `pwd` canonicalwebteam/python3 app.py
```

This will mount your application directory inside the container, install requirements from `./requirements.txt`, and then run `app.py`.

### Saving dependencies

The above command works but will install requirements from scratch every time it's run. To avoid this, create a named data volume for the installed python packages like so:

``` bash
$ docker run -ti \
         --volume `pwd`:`pwd`  \
         --workdir `pwd`  \
         --volume dependencies:/usr/local/lib/python3.6/site-packages  \
         --publish 8000:8000  \
         canonicalwebteam/python3 app.py
```

The first time you run the above command it will save the python packages into the a data volume called `dependencies`. On subsequent runs it will load the same data volume, and only re-install requirements if the `requirements` directory has been updated.

### Changing the path to your requirements file

You can use the `REQUIREMENTS_PATH` environment variable to specify a different location for `requirements.txt`. E.g., to run an app with a requirements file at `dev-requirements.txt`:

``` bash
docker run -ti  \
       --env REQUIREMENTS_PATH=dev-requiremnts.txt  \
       --volume `pwd`:`pwd`  \
       --workdir `pwd`  \
       --volume dependencies:/usr/local/lib/python3.6/site-packages  \
       --publish 8000:8000  \
       canonicalwebteam/python3 app.py
```
