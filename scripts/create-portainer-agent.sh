# Stop and remove existing container
docker stop portainer_agent
docker rm portainer_agent

# Pull new container
docker pull portainer/agent

# Run a new container
docker run -d \
  -p 9001:9001 \
  --name portainer_agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -v /:/host \
  portainer/agent
