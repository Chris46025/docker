FROM REGISTRY/FROM_IMAGE:VERSION
MAINTAINER Artem Golub <artemgolub@gmail.com>

ENTRYPOINT pip install -r /app/requirements/dev.txt && \
    python /app/backend/manage.py collectstatic --noinput && \
    python /app/backend/manage.py migrate && \
    mkdir -p /temp/uwsgi && \
    ln -s /app/config/wsgi.ini /temp/uwsgi/ && \
    uwsgi --emperor /temp/uwsgi/

EXPOSE 9000
