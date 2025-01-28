FROM python:3.12-slim

RUN python -m venv venv

ADD ./start.sh \
    ./serve.py \
    /scripts/

ENV PYPI_SERVER_URL=https://pypi.simiansuite.com \
    PIP_CERT=/etc/ssl/certs/ca-certificates.crt \
    APPS_FOLDER=/scripts/apps \
    GUNICORN_WORKERS=4 \
    SIMIAN_PRE=

EXPOSE 5000

CMD /bin/bash /scripts/start.sh
