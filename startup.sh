#!/bin/bash

cmd="java -jar eureka-server-0.0.1-SNAPSHOT.jar --spring.config.location=application.yaml"

if [[ ! -z "$EUREKA_CLUSTER_LIST" ]]; then 
  cmd="$cmd --eureka.client.serviceUrl.defaultZone=$EUREKA_CLUSTER_LIST"
fi

echo "executing cmd: $cmd"

$cmd