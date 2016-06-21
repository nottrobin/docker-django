FROM python:2.7

# Add binaries to image
ADD bin /bin/
ADD entrypoint /entrypoint

# Persist the requirements data
ENV MODULES_DIR="/usr/local/lib/python2.7/site-packages" \
    DB_HOST="db" \
    DB_PORT="5432" \
    REQUIREMENTS_PATH="requirements/dev.txt" \
    REQUIREMNETS_CONTAINER="requirements"
VOLUME [$MODULES_DIR]

ENTRYPOINT ["/entrypoint"]

WORKDIR /app
