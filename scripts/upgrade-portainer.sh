
# Stop and remove existing container
docker stop portainer
docker rm portainer

# Pull new container
docker pull portainer/portainer-ee:2.21.4

# Run a new container
docker run -d -p 8000:8000 \
-p 9443:9443 \
--name=portainer \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data portainer/portainer-ee:2.21.4 \
-v /certs/app.dipuce.com:/etc/ssl \
--sslcert /etc/ssl/fullchain.cer \
--sslkey /etc/ssl/app.dipuce.com.key