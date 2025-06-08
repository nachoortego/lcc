#!/bin/bash

while :; do
	K=$(((K+1) % 100000))
	echo "PUT $K $K"
	echo "GET $K"
done | nc localhost 8888 | pv >/dev/null
