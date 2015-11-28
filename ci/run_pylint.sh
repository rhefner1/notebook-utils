#!/usr/bin/env bash

if [[ $RUN_PYLINT == true ]]
then
    echo -e "### Adding SDK to Python path"
    export PYTHONPATH="${PYTHONPATH}:$(pwd)/ci/google_appengine"
    export PYTHONPATH="${PYTHONPATH}:$(pwd)/ci/google_appengine/lib/yaml-3.10"
    echo "Current PYTHONPATH: ${PYTHONPATH}"

    echo -e "\n### Running pylint"
    pylint ./controller --ignore lib --disable=no-member
fi
