# build docker image
docker build -f Dockerfile --rm -t docker_slowfast_nb .

#run on local with docker
docker run --gpus all \
--shm-size=8g -it \
--ipc="host" \
--volume=/home/haritha/datasets/Kinetics-Netball:/app/data \
--volume=/home/haritha/results/slowfast-netball:/app/results \
docker_slowfast_nb