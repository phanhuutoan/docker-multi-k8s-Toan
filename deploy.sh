#!/bin/bash

docker build -t superknife0512/multi-client:latest -t superknife0512/multi-client:$SHA -f client/Dockerfile ./client
docker build -t superknife0512/multi-worker:latest -t superknife0512/multi-worker:$SHA -f worker/Dockerfile ./worker
docker build -t superknife0512/multi-server:latest -t superknife0512/multi-server:$SHA -f server/Dockerfile ./server

docker push superknife0512/multi-client:latest
docker push superknife0512/multi-server:latest
docker push superknife0512/multi-worker:latest

docker push superknife0512/multi-client:$SHA
docker push superknife0512/multi-server:$SHA
docker push superknife0512/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployment/server-deployment multi-server=superknife0512/multi-server:$SHA
kubectl set image deployment/worker-deployment multi-worker=superknife0512/multi-worker:$SHA
kubectl set image deployment/client-deployment multi-client=superknife0512/multi-client:$SHA