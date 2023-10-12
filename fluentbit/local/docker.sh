#!/bin/bash

docker build -t fluentbit-local:latest .
docker stop fluentbit-local
docker rm fluentbit-local

docker run -d --name fluentbit-local -p 8888:8888 -p 8889:8889 -p 8890:8890 --network test-network fluentbit-local:latest