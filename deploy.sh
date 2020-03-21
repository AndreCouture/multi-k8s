#!/bin/sh

docker build -t andrecouture/multi-client:latest -t andrecouture/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t andrecouture/multi-server:latest -t andrecouture/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t andrecouture/multi-worker:latest -t andrecouture/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

docker push andrecouture/multi-client:latest
docker push andrecouture/multi-server:latest
docker push andrecouture/multi-worker:latest

docker push andrecouture/multi-client:$GIT_SHA
docker push andrecouture/multi-server:$GIT_SHA
docker push andrecouture/multi-worker:$GIT_SHA

kubectl apply -f ./k8s
kubectl set image deployments/client-deployment client=andrecouture/multi-client:$GIT_SHA
kubectl set image deployments/server-deployment server=andrecouture/multi-server:$GIT_SHA
kubectl set image deployments/worker-deployment worker=andrecouture/multi-worker:$GIT_SHA
