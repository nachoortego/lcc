#!/bin/bash

while :; do
	K=$(((K+1) % 100000))
	echo "GET $K"
done | nc localhost 8888  &>/dev/null
