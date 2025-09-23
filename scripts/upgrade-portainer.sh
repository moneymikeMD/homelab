
# Stop and remove existing container
docker stop portainer
docker rm portainer

# Pull new container
docker pull portainer/portainer-ee

# Run a new container
docker run -d \
-p 8000:8000 \
-p 9443:9443 \
--name=portainer \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data \
-v /certs/app.dipuce.com:/etc/user-ssl \
portainer/portainer-ee \
--sslcert /etc/user-ssl/fullchain.cer \
--sslkey /etc/user-ssl/app.dipuce.com.key
