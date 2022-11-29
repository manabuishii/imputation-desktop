#!/bin/bash

nohup node_modules/.bin/yarn start &
echo $! > pid.txt

