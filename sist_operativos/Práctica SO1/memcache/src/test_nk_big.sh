#!/bin/bash

V=$(xxd -p /dev/urandom | tr -d '\n' | head -c 2000)
while :; do
	K=$((K+1))
	echo "PUT $K $V"
	echo "GET $K"
done | nc localhost 8888 | pv >/dev/null
