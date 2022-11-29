#!/bin/bash

cd imputation-server-ui
./stop-imputation-server-ui.sh
cd ..
cd sapporo-service
./stop-sapporo-service.sh
cd ..
cd sapporo-web
./stop-sapporo-web.sh
cd ..
