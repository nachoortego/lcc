#!/bin/bash

K=$1
N=0
while :; do
	echo "PUT $K $N"
	echo "GET $K"
	N=$((N+1))
done | nc localhost 8888
