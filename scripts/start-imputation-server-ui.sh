#!/bin/bash

source venv-imputationserver-web-ui/bin/activate
nohup python3 app.py &
echo $! > pid.txt

