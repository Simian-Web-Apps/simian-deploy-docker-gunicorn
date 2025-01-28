#!/bin/bash
apt-get update
tr -d '\r' < /scripts/apt-get-packages.txt | xargs -t apt-get -y install
update-ca-certificates --fresh > /dev/null
source venv/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade fastapi uvicorn[standard] gunicorn
python -m pip install --upgrade --extra-index-url $PYPI_SERVER_URL $SIMIAN_PRE simian-gui
python -m pip install --upgrade -r /scripts/requirements.txt
python -m pip list
cd scripts
export PYTHONPATH="$(printf "%s:" $APPS_FOLDER/*/)"
python -m gunicorn serve:app --workers $GUNICORN_WORKERS --max-requests 1 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:5000
