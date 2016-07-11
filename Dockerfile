FROM python:2.7

# Expect to find application in /app
WORKDIR /app

# Expect to find the entrypoint script at /entrypoint
ENTRYPOINT ["/entrypoint"]

# Attempt to indicate debug mode to the Django app
ENV DJANGO_DEBUG="true"
ENV SECRET_KEY="no_secret"

# Default config for database service
ENV DB_HOST="db" DB_PORT="5432"

# Default config for where we expect to find requirements
ENV REQUIREMENTS_PATH="requirements/dev.txt" REQUIREMENTS_CONTAINER="requirements"

# Persist the requirements data
ENV MODULES_DIR="/usr/local/lib/python2.7/site-packages"
VOLUME [$MODULES_DIR] 

# Add binaries to image
ADD entrypoint /entrypoint
ADD bin /bin/

