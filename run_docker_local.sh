# build docker image
docker build -f Dockerfile --rm -t docker_slowfast .

#run on local with docker
docker run --gpus all \
--shm-size=8g -it \
--ipc="host" \
--volume=/media/haritha/Storage/Datasets/Kinetics-400-resized:/data \
docker_slowfast