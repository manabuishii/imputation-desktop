#!/bin/bash

source venv-sapporo-service/bin/activate
nohup python3 sapporo/app.py --host=0.0.0.0 --run-sh sapporo/run.sh  --executable-workflows sapporo/executable_workflows.json &
echo $! > pid.txt

