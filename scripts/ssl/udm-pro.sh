# A script to update the SSL certs on my UDM Pro
# Adapted from https://github.com/ScottHelme/ubiquiti-https-scripts/blob/main/udm-pro.sh
# 1.139 being docker-host; 1.1 being UDM

# Grab cert files and copy locally
echo "Grabbing files from Docker host"
ssh mike@10.100.1.139 "sudo -S cat /certs/home.dipuce.com/fullchain.cer" > ./fullchain.cer
ssh mike@10.100.1.139 "sudo -S cat /certs/home.dipuce.com/home.dipuce.com.key" > ./dipuce.key

echo "Transfering files to UDM Pro"
scp fullchain.cer root@10.100.1.1:/data/unifi-core/config/unifi-core.crt
scp dipuce.key root@10.100.1.1:/data/unifi-core/config/unifi-core.key
ssh root@10.100.1.1 'systemctl restart unifi-core'

echo "Removing copied files"
rm fullchain.cer
rm dipuce.key