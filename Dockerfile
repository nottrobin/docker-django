FROM python:2.7

# Expect to find the entrypoint script at /entrypoint
ENTRYPOINT ["/entrypoint"]

# Default config for database service
ENV DB_HOST="db"
ENV DB_PORT="5432"

# Debug tools
RUN pip install ipdb

# Default config for where we expect to find requirements
ENV REQUIREMENTS_PATH="requirements.txt"
ENV REQUIREMENTS_HASH="/usr/local/lib/python2.7/site-packages/requirements.md5"

# Ensure all users can create dependencies
RUN chmod -R 777 /usr/local/lib/python2.7/site-packages/ /usr/local/bin/

# Create a shared home directory
# This helps anonymous users have a home
ENV HOME=/home/shared
RUN mkdir -p $HOME
RUN chmod -R 777 $HOME

# Add binaries to image
ADD entrypoint /entrypoint

