# feb/13/2020 00:08:16 by RouterOS 6.45.8
# software id = EXEI-2QTY
#
# model = RBD52G-5HacD2HnD
# serial number = B4A10B9E8CEA
/interface bridge
add admin-mac=C4:AD:34:7A:EC:04 auto-mac=no comment=defconf name=bridge
add comment="WISP_config (will be used for ubiquity LAP120)" name=\
    bridge_WISP_AP
add comment=hotspot_config name=bridge_hotspot
/interface ethernet
set [ find default-name=ether1 ] comment=ISP1 name=ether1_WAN1
set [ find default-name=ether2 ] comment=ISP2 name=ether2_WAN2
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa-psk,wpa2-psk eap-methods="" \
    supplicant-identity=MikroTik wpa-pre-shared-key=wifiwifi \
    wpa2-pre-shared-key=wifiwifi
add authentication-types=wpa2-psk eap-methods="" management-protection=\
    allowed mode=dynamic-keys name=wifiwifi supplicant-identity="" \
    wpa2-pre-shared-key=wifiwifi
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-XX \
    country=philippines disabled=no distance=indoors frequency=auto \
    installation=indoor mode=ap-bridge security-profile=wifiwifi ssid=\
    "hAP ac2 2GHz" wireless-protocol=802.11
set [ find default-name=wlan2 ] band=5ghz-a/n/ac channel-width=\
    20/40/80mhz-XXXX country=philippines disabled=no distance=indoors \
    frequency=auto installation=indoor mode=ap-bridge security-profile=\
    wifiwifi ssid="hAP ac2 5GHz" wireless-protocol=802.11
add comment=hotspot_config disabled=no keepalive-frames=disabled mac-address=\
    02:00:00:AA:00:00 master-interface=wlan1 multicast-buffering=disabled \
    name=vwlan1_hotspot ssid=hotspot wds-cost-range=0 wds-default-cost=0 \
    wps-mode=disabled
/interface wireless manual-tx-power-table
set vwlan1_hotspot comment=hotspot_config
/interface wireless nstreme
set vwlan1_hotspot comment=hotspot_config
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
add dns-name=bananaconnection.com hotspot-address=10.10.8.1 html-directory=\
    flash/hotspot login-by=cookie,http-chap,trial name=hsprof1 \
    trial-uptime-limit=15m
/ip pool
add name=dhcp ranges=192.168.88.10-192.168.88.254
add comment=hotspot_config name=pool_hotspot ranges=10.10.8.2-10.10.8.254
/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge name=defconf
add address-pool=pool_hotspot disabled=no interface=bridge_hotspot name=\
    dhcp_hotspot
/ip hotspot
add address-pool=pool_hotspot addresses-per-mac=1 disabled=no interface=\
    bridge_hotspot name=hotspot profile=hsprof1
/ip hotspot user profile
add address-pool=pool_hotspot name=1hr on-login=":put (\",rem,5,1h,5,,Disable,\
    \"); {:local date [ /system clock get date ];:local year [ :pick \$date 7 \
    11 ];:local month [ :pick \$date 0 3 ];:local comment [ /ip hotspot user g\
    et [/ip hotspot user find where name=\"\$user\"] comment]; :local ucode [:\
    pic \$comment 0 2]; :if (\$ucode = \"vc\" or \$ucode = \"up\" or \$comment\
    \_= \"\") do={ /sys sch add name=\"\$user\" disable=no start-date=\$date i\
    nterval=\"1h\"; :delay 2s; :local exp [ /sys sch get [ /sys sch find where\
    \_name=\"\$user\" ] next-run]; :local getxp [len \$exp]; :if (\$getxp = 15\
    ) do={ :local d [:pic \$exp 0 6]; :local t [:pic \$exp 7 16]; :local s (\"\
    /\"); :local exp (\"\$d\$s\$year \$t\"); /ip hotspot user set comment=\$ex\
    p [find where name=\"\$user\"];}; :if (\$getxp = 8) do={ /ip hotspot user \
    set comment=\"\$date \$exp\" [find where name=\"\$user\"];}; :if (\$getxp \
    > 15) do={ /ip hotspot user set comment=\$exp [find where name=\"\$user\"]\
    ;}; /sys sch remove [find where name=\"\$user\"]}}" parent-queue=none \
    transparent-proxy=yes
add address-pool=pool_hotspot name=1day on-login=":put (\",rem,50,1d,50,,Disab\
    le,\"); {:local date [ /system clock get date ];:local year [ :pick \$date\
    \_7 11 ];:local month [ :pick \$date 0 3 ];:local comment [ /ip hotspot us\
    er get [/ip hotspot user find where name=\"\$user\"] comment]; :local ucod\
    e [:pic \$comment 0 2]; :if (\$ucode = \"vc\" or \$ucode = \"up\" or \$com\
    ment = \"\") do={ /sys sch add name=\"\$user\" disable=no start-date=\$dat\
    e interval=\"1d\"; :delay 2s; :local exp [ /sys sch get [ /sys sch find wh\
    ere name=\"\$user\" ] next-run]; :local getxp [len \$exp]; :if (\$getxp = \
    15) do={ :local d [:pic \$exp 0 6]; :local t [:pic \$exp 7 16]; :local s (\
    \"/\"); :local exp (\"\$d\$s\$year \$t\"); /ip hotspot user set comment=\$\
    exp [find where name=\"\$user\"];}; :if (\$getxp = 8) do={ /ip hotspot use\
    r set comment=\"\$date \$exp\" [find where name=\"\$user\"];}; :if (\$getx\
    p > 15) do={ /ip hotspot user set comment=\$exp [find where name=\"\$user\
    \"];}; /sys sch remove [find where name=\"\$user\"]}}" parent-queue=none \
    transparent-proxy=yes
/queue tree
add max-limit=10M name="Global DL Speed" parent=global
add max-limit=5M name="Global UL Speed" parent=global
/queue type
add kind=pcq name="Global Limiter (DL)" pcq-classifier=src-address,src-port \
    pcq-rate=256k
add kind=pcq name="Global Limiter (UL)" pcq-classifier=dst-address,dst-port \
    pcq-rate=256k
/queue tree
add limit-at=6M max-limit=6M name="Browsing DL Speed" packet-mark=DL&Browsing \
    parent="Global DL Speed" queue="Global Limiter (DL)"
add max-limit=2M name="Other DL Speed" packet-mark=\
    "Untracked General Ports (DL)" parent="Global DL Speed" queue=\
    "Global Limiter (DL)"
add name="Gaming Connection Speed" packet-mark="Game Download" parent=\
    "Global DL Speed" priority=1 queue=default
add limit-at=3M max-limit=3M name="Browsing UL Speed" packet-mark=UL&Browsing \
    parent="Global UL Speed" queue="Global Limiter (UL)"
add name="Gaming UL Speed" packet-mark="Game Upload" parent="Global UL Speed" \
    priority=1 queue=default
add max-limit=1M name="Other UL Speed" packet-mark=\
    "Untracked General Ports (UL)" parent="Global UL Speed" queue=\
    "Global Limiter (UL)"
/interface bridge port
add bridge=bridge_WISP_AP comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge comment=defconf interface=ether5
add bridge=bridge comment=defconf interface=wlan1
add bridge=bridge comment=defconf interface=wlan2
add bridge=bridge_hotspot comment=hotspot_config interface=vwlan1_hotspot
add bridge=bridge comment=defconf interface=ether2_WAN2
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface detect-internet
set detect-interface-list=all
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1_WAN1 list=WAN
/ip address
add address=192.168.88.1/24 comment=defconf interface=ether2_WAN2 network=\
    192.168.88.0
add address=10.10.8.1/24 comment=hotspot_config interface=bridge_hotspot \
    network=10.10.8.0
add address=10.10.2.1/24 interface=bridge_WISP_AP network=10.10.2.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid disabled=no interface=\
    ether1_WAN1
/ip dhcp-server network
add address=10.10.8.0/24 comment=hotspot_config gateway=10.10.8.1
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 comment=defconf name=router.lan
/ip firewall address-list
add address=10.10.8.0/24 list=all_host_IP
add address=10.10.2.0/24 list=all_host_IP
add address=192.168.88.0/24 list=all_host_IP
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here"
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment=\
    "defconf: accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related disabled=yes
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall mangle
add action=mark-connection chain=prerouting comment=\
    bandwidth_management_config_General_Ports_TCP dst-port=\
    21,22,23,81,88,5050,843,182,8777,1935,53,8000-8081,443,80 in-interface=\
    !ether1_WAN1 new-connection-mark="General Ports" passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    67,5228,35915,39397,110,5060,6666,3478,66,53,8080 in-interface=\
    !ether1_WAN1 new-connection-mark="General Ports" passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting comment=\
    bandwidth_management_config_General_Ports_UDP dst-port=\
    67,5228,35915,39397,110,5060,6666,3478,66,53,8080 in-interface=\
    !ether1_WAN1 new-connection-mark="General Ports" passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    21,22,23,81,88,5050,843,182,8777,1935,53,8000-8081,443,80 in-interface=\
    !ether1_WAN1 new-connection-mark="General Ports" passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting comment=\
    bandwidth_management_config_Game_Ports_TCP connection-mark=\
    "!General Ports" in-interface=!ether1_WAN1 new-connection-mark=\
    "Game Ports" passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=\
    bandwidth_management_config_Game_Ports_UDP connection-mark=\
    "!General Ports" in-interface=!ether1_WAN1 new-connection-mark=\
    "Game Ports" passthrough=yes protocol=udp
add action=mark-packet chain=forward comment=\
    bandwidth_management_config_Game_Upload connection-mark="Game Ports" \
    new-packet-mark="Game Upload" out-interface=ether1_WAN1 passthrough=yes
add action=mark-packet chain=forward comment=\
    bandwidth_management_config_Game_Download connection-mark="Game Ports" \
    in-interface-list=WAN new-packet-mark="Game Download" passthrough=yes
add action=mark-packet chain=DL&Browsing comment=\
    bandwidth_management_config_DL&Browsing connection-mark="General Ports" \
    new-packet-mark=DL&Browsing passthrough=yes
add action=jump chain=forward connection-mark="!Game Ports" dst-address-list=\
    all_host_IP jump-target=DL&Browsing out-interface=ether1_WAN1
add action=mark-packet chain=UL&Browsing comment=\
    bandwidth_management_config_UL&Browsing connection-mark="General Ports" \
    new-packet-mark=UL&Browsing passthrough=yes
add action=jump chain=forward connection-mark="!General Ports" jump-target=\
    UL&Browsing out-interface=ether1_WAN1 src-address-list=all_host_IP
add action=add-dst-to-address-list address-list="other connection port" \
    address-list-timeout=3m chain=prerouting comment=\
    bandwidth_management_config_Other_connection_port connection-mark=\
    "!General Ports" connection-rate=1M-10M dst-address-list=!all_host_IP \
    in-interface=!ether1_WAN1 protocol=tcp
add action=add-dst-to-address-list address-list="other connection port" \
    address-list-timeout=3m chain=prerouting connection-mark="!General Ports" \
    connection-rate=1M-10M dst-address-list=!all_host_IP in-interface=\
    !ether1_WAN1 protocol=udp
add action=mark-connection chain=prerouting comment="Untracked Connections" \
    dst-address-list="other connection port" in-interface=!ether1_WAN1 \
    new-connection-mark="Untracked Ports" passthrough=yes
add action=mark-packet chain=forward connection-mark="Untracked Ports" \
    in-interface=ether1_WAN1 new-packet-mark="Untracked General Ports (DL)" \
    passthrough=yes
add action=mark-packet chain=forward connection-mark="Untracked Ports" \
    new-packet-mark="Untracked General Ports (UL)" out-interface=ether1_WAN1 \
    passthrough=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.10.8.0/24
/ip hotspot user
add name=admin password=admin
add disabled=yes limit-uptime=30s name=test password=test server=hotspot
add comment=up-986-02.06.20-1hour limit-uptime=1h name=dbyvrk password=957282 \
    profile=1hr server=hotspot
add comment=up-986-02.06.20-1hour limit-uptime=1h name=ssiect password=394939 \
    profile=1hr server=hotspot
add comment=up-986-02.06.20-1hour limit-uptime=1h name=bwugmd password=254347 \
    profile=1hr server=hotspot
/system clock
set time-zone-name=Asia/Manila
/system identity
set name="hAP ac2"
/system logging
add action=disk prefix=-> topics=hotspot,info,debug
/system scheduler
add comment="Monitor Profile 1hr" interval=2m49s name=1hr on-event=":local dat\
    eint do={:local montharray ( \"jan\",\"feb\",\"mar\",\"apr\",\"may\",\"jun\
    \",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );:local days [ :pick \
    \$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [ :pick \$d 7 11 ];:l\
    ocal monthint ([ :find \$montharray \$month]);:local month (\$monthint + 1\
    );:if ( [len \$month] = 1) do={:local zero (\"0\");:return [:tonum (\"\$ye\
    ar\$zero\$month\$days\")];} else={:return [:tonum (\"\$year\$month\$days\"\
    )];}}; :local timeint do={ :local hours [ :pick \$t 0 2 ]; :local minutes \
    [ :pick \$t 3 5 ]; :return (\$hours * 60 + \$minutes) ; }; :local date [ /\
    system clock get date ]; :local time [ /system clock get time ]; :local to\
    day [\$dateint d=\$date] ; :local curtime [\$timeint t=\$time] ; :foreach \
    i in [ /ip hotspot user find where profile=\"1hr\" ] do={ :local comment [\
    \_/ip hotspot user get \$i comment]; :local name [ /ip hotspot user get \$\
    i name]; :local gettime [:pic \$comment 12 20]; :if ([:pic \$comment 3] = \
    \"/\" and [:pic \$comment 6] = \"/\") do={:local expd [\$dateint d=\$comme\
    nt] ; :local expt [\$timeint t=\$gettime] ; :if ((\$expd < \$today and \$e\
    xpt < \$curtime) or (\$expd < \$today and \$expt > \$curtime) or (\$expd =\
    \_\$today and \$expt < \$curtime)) do={ [ /ip hotspot user remove \$i ]; [\
    \_/ip hotspot active remove [find where user=\$name] ];}}}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=feb/06/2020 start-time=01:41:13
add comment="Monitor Profile 1day" interval=2m19s name=1day on-event=":local d\
    ateint do={:local montharray ( \"jan\",\"feb\",\"mar\",\"apr\",\"may\",\"j\
    un\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );:local days [ :pick\
    \_\$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [ :pick \$d 7 11 ];\
    :local monthint ([ :find \$montharray \$month]);:local month (\$monthint +\
    \_1);:if ( [len \$month] = 1) do={:local zero (\"0\");:return [:tonum (\"\
    \$year\$zero\$month\$days\")];} else={:return [:tonum (\"\$year\$month\$da\
    ys\")];}}; :local timeint do={ :local hours [ :pick \$t 0 2 ]; :local minu\
    tes [ :pick \$t 3 5 ]; :return (\$hours * 60 + \$minutes) ; }; :local date\
    \_[ /system clock get date ]; :local time [ /system clock get time ]; :loc\
    al today [\$dateint d=\$date] ; :local curtime [\$timeint t=\$time] ; :for\
    each i in [ /ip hotspot user find where profile=\"1day\" ] do={ :local com\
    ment [ /ip hotspot user get \$i comment]; :local name [ /ip hotspot user g\
    et \$i name]; :local gettime [:pic \$comment 12 20]; :if ([:pic \$comment \
    3] = \"/\" and [:pic \$comment 6] = \"/\") do={:local expd [\$dateint d=\$\
    comment] ; :local expt [\$timeint t=\$gettime] ; :if ((\$expd < \$today an\
    d \$expt < \$curtime) or (\$expd < \$today and \$expt > \$curtime) or (\$e\
    xpd = \$today and \$expt < \$curtime)) do={ [ /ip hotspot user remove \$i \
    ]; [ /ip hotspot active remove [find where user=\$name] ];}}}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=feb/06/2020 start-time=03:37:38
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
