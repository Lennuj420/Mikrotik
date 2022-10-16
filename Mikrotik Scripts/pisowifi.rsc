#add new virtual wlan for pisowifi
# /interface wireless add name="pisowifi_wlan" mode=ap-bridge ssid="Banana i-Connection" master-interface=wlan1 security-profile=default  wps-mode=disabled disabled=no comment="pisowifi";

#add bridge for pisowifi
/interface bridge add name="pisowifi_bridge" comment="pisowifi";

#add ip address for pisowifi bridge
/ip address add address=10.0.0.1/24 interface="pisowifi_bridge" comment="pisowifi"

#add ip pool to be used by hot spot users
/ip pool add name="pisowifi_ip_pool" ranges=10.0.0.10-10.0.0.254 comment="pisowifi"

#add dhcp server to be used by the pisowifi
/ip dhcp-server add name="pisowifi_dhcp_server" address-pool="pisowifi_ip_pool" interface="pisowifi_bridge" authoritative=after-2sec-delay lease-time=1h disabled=no

#add dhcp network to be used by pisowifi
/ip dhcp-server network add address=10.0.0.0/24 gateway=10.0.0.1 comment="pisowifi"

#add pisowifi user profile to be used by pisowifi user
#trial
/ip hotspot user profile add name="trial" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=1d

#pisowifi
/ip hotspot user profile add name="pisowifi" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=1d

#1peso = 5mins
/ip hotspot user profile add name="1peso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=1d

#5peso = 30mins
/ip hotspot user profile add name="5peso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=1d

#10peso = 2hours
/ip hotspot user profile add name="10peso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=1d

#20peso = 6hours
/ip hotspot user profile add name="20peso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=1d

#30peso = 1day
/ip hotspot user profile add name="30peso" idle-timeout=1d keepalive-timeout=1d status-autorefresh=5 rate-limit=1M/2M mac-cookie-timeout=3d


#add pisowifi server profile to be used by  pisowifi server
/ip hotspot profile add name="pisowifi" hotspot-address=10.0.0.1 dns-name="pisowifi.portal" html-directory="pisowifi" login-by=http-chap,trial,cookie trial-uptime-limit=5m trial-uptime-reset=1d trial-user-profile="trial"

#add pisowifi server
/ip hotspot add name=pisowifi interface="pisowifi_bridge" address-pool="pisowifi_ip_pool" profile=pisowifi addresses-per-mac=1 disabled=no

#add admin account for pisowifi
/ip hotspot user add server=all name=admin password=Admmin1 profile=default 


#add nodemcu access to walled garden
/ip hotspot walled-garden ip add action=accept dst-port=8728 protocol=tcp disabled=no  comment="api access";

#add qrcode scanner site to walled garden
/ip hotspot walled-garden ip add action=accept dst-host="laksa19.github.io" disabled=no  comment="QR Code scanner";

#add admin user to be used by node module
/user add name="Nodemodule1" password="Nodemodule1" group=full disabled=no comment="node module account";

#add pisowifi virtual wlan to the pisowifi bridge
/interface bridge port add interface=[/interface get [find default-name~"wlan1"] name] bridge="pisowifi_bridge"

#set wlan for pisowifi
/interface wireless set [/interface get [find default-name~"wlan1"] name] name="pisowifi_wlan" mode=ap-bridge band=2ghz-b/g/n channel-width=20/40mhz-XX frequency=auto ssid="Banana i-Connection" security-profile=default frequency-mode=superchannel country=no_country_set default-forwarding=no comment="pisowifi"
