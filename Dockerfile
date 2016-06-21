FROM python:2

# Add binaries to image
ADD bin /bin/
ADD entrypoint /entrypoint

# Persist the requirements data
ENV MODULES_DIR="/usr/local/lib/python3.5/site-packages" DB_HOST="db"
VOLUME [$MODULES_DIR]

ENTRYPOINT ["/entrypoint"]

CMD ["./manage.py", "runserver", "0.0.0.0:5000"]
