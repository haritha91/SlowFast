# build docker image
docker build -f Dockerfile --rm -t docker_slowfast .

#run on local with docker
docker run --gpus all \
--shm-size=8g -it \
--ipc="host" \
--volume=/home/haritha/datasets/Kinetics-400-resized:/app/data \
docker_slowfast