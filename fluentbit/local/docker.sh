#!/bin/bash

docker build -t fluentbit-local:latest .
docker run -d --name fluentbit-local -p 8888:8888 -p 8889:8889 fluentbit-local:latest