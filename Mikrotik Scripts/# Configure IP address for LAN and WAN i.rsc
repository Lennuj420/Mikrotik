# Configure IP address for LAN and WAN interfaces / zaib
/ip address
add address=172.16.0.1/24 comment=LAN disabled=no interface=ether1 network=172.16.0.0
add address=192.168.2.1/24 comment=WAN disabled=no interface=ether2 network=192.168.2.0
 
# ADD IP pool for hotspot users
/ip pool
add name=hs-pool-1 ranges=172.16.0.10-172.16.0.255
 
# Add GOOGLE DNS for resolving
/ip dns
set allow-remote-requests=yes cache-max-ttl=1w cache-size=10000KiB max-udp-packet-size=512 servers=8.8.8.8
 
# Add DHCP Server
/ip dhcp-server
add address-pool=hs-pool-1 authoritative=after-2sec-delay bootp-support=static disabled=no interface=ether1 lease-time=1h name=dhcp1
 
/ip dhcp-server config set store-leases-disk=5m
 
/ip dhcp-server network add address=172.16.0.0/24 comment="hotspot network" gateway=172.16.0.1
 
# Add HOTSPOT profile
/ip hotspot profile
 
set default dns-name="" hotspot-address=0.0.0.0 html-directory=hotspot http-cookie-lifetime=3d http-proxy=0.0.0.0:0 login-by=cookie,http-chap name=default rate-limit="" smtp-server=0.0.0.0 split-user-domain=no use-radius=no
 
add dns-name=login.aacable.net hotspot-address=172.16.0.1 html-directory=hotspot http-cookie-lifetime=1d http-proxy=0.0.0.0:0 login-by=cookie,http-chap name=hsprof1 rate-limit="" smtp-server=0.0.0.0 split-user-domain=no use-radius=no
 
/ip hotspot
add address-pool=hs-pool-1 addresses-per-mac=2 disabled=no idle-timeout=5m interface=ether1 keepalive-timeout=none name=hotspot1 profile=hsprof1
 
# Add HOTSPOT User Profile like 256k and 512k
/ip hotspot user profile set default idle-timeout=none keepalive-timeout=2m name=default shared-users=1 status-autorefresh=1m transparent-proxy=no add address-pool=hs-pool-1 advertise=no idle-timeout=none keepalive-timeout=2m name="512k Limit" open-status-page=always rate-limit=512k/512k shared-users=1 status-autorefresh=1m transparent-proxy=yes add address-pool=hs-pool-1 advertise=no idle-timeout=none keepalive-timeout=2m name="256k Limit" open-status-page=always rate-limit=256k/256k shared-users=1 status-autorefresh=1m transparent-proxy=yes /ip hotspot service-port set ftp disabled=yes ports=21 /ip hotspot walled-garden ip add action=accept disabled=no dst-address=172.16.0.1 /ip hotspot set numbers=hotspot1 address-pool=none /ip firewall nat add action=masquerade chain=srcnat disabled=no /ip hotspot user add disabled=no name=admin password=123 profile=default add disabled=no name=zaib password=test profile="512k Limit" server=hotspot1 add disabled=no name=test-256k password=test profile="256k Limit" server=hotspot1 /ip route add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=192.168.2.2 scope=30 target-scope=10