#todo
#create admin user for node modul - ok
#create virtual wlan for hotspot -ok
#create hotspot (10.0.0.1) - ok
#add walled garden to access router via winbox only



#add admin user to be used by node module
/user add name="NodeModule1" password="NodeModule1" group=full disabled=no comment="node module account";

#add new virtual wlan for hotspot
/interface wireless add name="hotspot_wlan" mode=ap-bridge ssid=🍌Hotspot🍌 master-interface=wlan1 security-profile=default  wps-mode=disabled disabled=no comment="hotspot";

#add bridge for hotspot
/interface bridge add name="hotspot_bridge" comment="hotspot";

#add ip address for hotspot bridge
/ip address add address=10.0.0.1/24 interface="hotspot_bridge" comment="hotspot"

#add hotspot virtual wlan to the hotspot bridge
/interface bridge port add interface="hotspot_wlan" bridge="hotspot_bridge"

#add ip pool to be used by hot spot users
/ip pool add name="hotspot_ip_pool" ranges=10.0.0.10-10.0.0.254 comment="hotspot"

#add dhcp server to be used by the hotspot
/ip dhcp-server add name="hotspot_dhcp_server" pool="hotspot_ip_pool" interface="hotspot_bridge" authoritative=after-2sec-delay lease-time=1h disabled=no

#add dhcp network to be used by hotspot
/ip dhcp-server network add address=10.0.0.0/24 gateway=10.0.0.1 co
mment="hotspot"

#add hotspot user profile to be used by hotspot user
#trial
/ip hotspot user profile add name="trial" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=3d

#1piso = 2mins
/ip hotspot user profile add name="1piso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=3d

#5piso = 15mins
/ip hotspot user profile add name="5piso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=3d

#10piso = 2hour
/ip hotspot user profile add name="10piso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=3d

#20piso = 6hours
/ip hotspot user profile add name="20piso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=3d

#40piso = 1day
/ip hotspot user profile add name="30piso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=3d

#add hotspot server profile to be used by  hotspot server
/ip hotspot profile add name="PisoWifi" dns-name="wifi.portal" hotspot-address=10.0.0.1 login-by=http-chap,trial,cookie trial-uptime-limit=10m trial-uptime-reset=1d trial-user-profile="trial"


#add hotspot server
/ip hotspot add name=PisoWifi interface="hotspot_bridge" address-pool="hotspot_ip_pool" profile=wifi.portal addresses-per-mac=1 disabled=no

# add nodemcu access to walled garden
/ip hotspot walled-garden ip add dst-port=8728 protocol=tcp server=pisowifi disabled=no;
#todo
#accept voucher only to login (voucher type login)




