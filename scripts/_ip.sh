#!/bin/bash

set -e

IP=`ifconfig eth1 | grep 'inet addr' | sed 's/.*addr:\([0-9.]*\) .*/\1/'`

echo "private network (eth1) IP address id $IP"
