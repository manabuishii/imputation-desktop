#!/bin/bash

function rpgrep(){
  local ppid=$1;
  for pid in $(pgrep -P $ppid); do
    echo $pid
    rpgrep $pid;
  done
}


SERVICEPID=$(cat pid.txt)
kill -9 $(rpgrep $SERVICEPID) $SERVICEPID
