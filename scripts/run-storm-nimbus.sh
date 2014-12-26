#!/bin/bash

if ! [ -d venv ]
then
  virtualenv venv
fi

. venv/bin/activate && \
  pip install -r requirements.txt && \
  python -m docker_python_helpers.run_storm_nimbus \
    docker_python_helpers/run_storm_nimbus.py $@ && \
  deactivate
