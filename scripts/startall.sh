#!/bin/bash

cd imputation-server-ui
./start-imputation-server-ui.sh
cd ..
cd sapporo-service
./start-sapporo-service.sh
cd ..
cd sapporo-web
./start-sapporo-web.sh
cd ..
