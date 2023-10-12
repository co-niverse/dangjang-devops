#!/bin/bash

docker build -t fluentbit-local:latest .
docker stop fluentbit-local
docker rm fluentbit-local

docker run -d --name fluentbit-local -p 8888:8888 --network test-network fluentbit-local:latest