#!/bin/bash

service appd-netviz start

while sleep 60; do
  ps aux |grep appd-netagent | grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep appd-netmon | grep -q -v grep
  PROCESS_2_STATUS=$?
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "Something went wrong!"
    exit 1
  fi
done

