#/usr/bin/env bash

IMAGE="registry.dl.cs.latrobe.edu.au/haritha/knt-1"

# 1. Build image
docker build . -t "$IMAGE"
# 2. Push image to cluster
docker push "$IMAGE"
# 3. Run container on cluster
kubectl apply -f pod.yml