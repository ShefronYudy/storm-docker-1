#!/bin/bash

if ! [ -d venv ]
then
  virtualenv venv
fi

. venv/bin/activate && \
  ($SKIP_PIP_INSTALL || pip install -r requirements.txt) && \
  python -m docker_python_helpers.run_zookeeper \
    docker_python_helpers/run_zookeeper.py $@ && \
  deactivate
