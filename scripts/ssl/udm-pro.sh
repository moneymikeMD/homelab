# A script to update the SSL certs on my UDM Pro
# Adapted from https://github.com/ScottHelme/ubiquiti-https-scripts/blob/main/udm-pro.sh
# 1.139 being docker-host; 1.1 being UDM
scp mike@10.100.1.139:/certs/home.dipuce.com/fullchain.cer root@10.100.1.1:/data/unifi-core/config/unifi-core.crt
scp mike@10.100.1.139:/certs/home.dipuce.com/home.dipuce.com.key root@10.100.1.1:/data/unifi-core/config/unifi-core.key
ssh root@10.100.1.1 'systemctl restart unifi-core'