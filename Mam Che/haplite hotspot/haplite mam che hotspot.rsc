# may/21/2020 22:45:54 by RouterOS 6.44.6
# software id = SSKD-KLII
#
# model = RB941-2nD
# serial number = D0560B9B4094
/interface bridge
add name=bridge1_local
add name=bridge2_hotspot
/interface ethernet
set [ find default-name=ether4 ] name=HOTSPOT4
set [ find default-name=ether2 ] name=LAN2
set [ find default-name=ether3 ] name=LAN3
set [ find default-name=ether1 ] name=WAN1
#/interface pwr-line
#set [ find default-name=pwr-line1 ] mac-address=B8:69:F4:2D:D9:82
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n country=philippines disabled=\
    no mode=ap-bridge ssid=Zer08ight wireless-protocol=802.11
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip firewall layer7-protocol
add name=speedtest regexp="^.+(speedtest).*\\\$"
add name=streaming regexp="^.+(.youtube.|ytimg|googlevideo.com|youtu.be).*\$"
add name=Block regexp="hotshotgames.net|memoryhackers.org|hax4you.com|exiledro\
    s.net|ramleague.net|arcai.com|www.logixoft.com"
add name="ADS BLOCKER" regexp="^.+(mesu.apple.com|appldnld.apple.com|icloud.ap\
    ple-dns.net|www.icloud.com|i.mi.com|www.icloud.com/photos|coinhive|ads|Pop\
    Ads|mining711.com|minero).*\\\$"
/ip hotspot profile
add dns-name=wifi.portal hotspot-address=10.10.10.1 login-by=\
    http-chap,http-pap,mac-cookie name=hsprof1
/ip pool
add name=dhcp_pool0 ranges=192.168.88.2-192.168.88.254
add name=hs-pool-8 ranges=10.10.10.2-10.10.10.254
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=bridge1_local name=dhcp1
add address-pool=hs-pool-8 disabled=no interface=bridge2_hotspot lease-time=\
    1h name=dhcp2
/ip hotspot
add address-pool=hs-pool-8 addresses-per-mac=1 disabled=no interface=\
    bridge2_hotspot name=hotspot1 profile=hsprof1
/queue tree
add name="GLOBAL CONNECTIONS" parent=global
add name=A.ALL-WAN-CONNECTIONS parent="GLOBAL CONNECTIONS"
add name=1.UNKNOWN-CONNECTIONS packet-mark=no-mark parent="GLOBAL CONNECTIONS"
/queue simple
add name=OnlineGames packet-marks="PORT OTHER THAN PORT GENERAL(GAME) DOWN WAN,PORT OTHER THAN PORT GENERAL(GAME) UP WAN" priority=1/1 queue=\
    pcq-upload-default/pcq-download-default target=192.168.88.0/24,10.10.10.0/24
add max-limit=4M/4M name=ICMP packet-marks="ICMP DOWN WAN,ICMP UP WAN" priority=1/1 queue=pcq-upload-default/pcq-download-default target=192.168.88.0/24,10.10.10.0/24
add max-limit=20M/20M name=All_Traffic packet-marks="PORT WEIGHT DOWN WAN,PORT_WEIGHT UP WAN,SPEEDTEST DOWN WAN,SPEEDTEST UP WAN,GENERAL WEIGHT DOWN WA
    N,GENERAL WEIGHT UP WAN,STREAMING VIDEO DOWN WAN,STREAMING VIDEO UP WAN,DOWNLOAD ALL WAN,UPLOAD ALL WAN" queue=pcq-upload-default/pcq-download-default target=192.168.88.0/24,10.10.10.0/24
add name=Hotspot_Users parent=All_Traffic queue=pcq-upload-default/pcq-download-default target=""
/ip hotspot user profile
set [ find default=yes ] idle-timeout=1d insert-queue-before=bottom \
    keepalive-timeout=1d mac-cookie-timeout=1d on-login="\r\
    \n\r\
    \n{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot cookie remove [find user=\$user]\\r\\n/ip hotspot user remove [fin\
    d name=\$user]\\r\\n/ip hotspot active remove [find user=\$user]\\r\\n/sys\
    tem scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}\r\
    \n" parent-queue=Hotspot_Users rate-limit=2M/2M
add idle-timeout=1d insert-queue-before=bottom keepalive-timeout=1d \
    mac-cookie-timeout=1d name=R1 on-login="\r\
    \n\r\
    \n{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot cookie remove [find user=\$user]\\r\\n/ip hotspot user remove [fin\
    d name=\$user]\\r\\n/ip hotspot active remove [find user=\$user]\\r\\n/sys\
    tem scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}\r\
    \n" parent-queue=Hotspot_Users rate-limit=2M/2M transparent-proxy=yes
add idle-timeout=1d insert-queue-before=bottom keepalive-timeout=1d \
    mac-cookie-timeout=1d name=R2 on-login="\r\
    \n\r\
    \n{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot cookie remove [find user=\$user]\\r\\n/ip hotspot user remove [fin\
    d name=\$user]\\r\\n/ip hotspot active remove [find user=\$user]\\r\\n/sys\
    tem scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}\r\
    \n" parent-queue=Hotspot_Users rate-limit=2M/2M transparent-proxy=yes
add idle-timeout=1d insert-queue-before=bottom keepalive-timeout=1d \
    mac-cookie-timeout=1d name=R3 on-login="\r\
    \n\r\
    \n{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot cookie remove [find user=\$user]\\r\\n/ip hotspot user remove [fin\
    d name=\$user]\\r\\n/ip hotspot active remove [find user=\$user]\\r\\n/sys\
    tem scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}\r\
    \n" parent-queue=Hotspot_Users rate-limit=2M/2M transparent-proxy=yes
add idle-timeout=1d insert-queue-before=bottom keepalive-timeout=1d \
    mac-cookie-timeout=1d name=R4 on-login="\r\
    \n\r\
    \n{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot cookie remove [find user=\$user]\\r\\n/ip hotspot user remove [fin\
    d name=\$user]\\r\\n/ip hotspot active remove [find user=\$user]\\r\\n/sys\
    tem scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}\r\
    \n" parent-queue=Hotspot_Users rate-limit=2M/2M transparent-proxy=yes
add idle-timeout=1d insert-queue-before=bottom keepalive-timeout=1d \
    mac-cookie-timeout=1d name=R5 on-login="\r\
    \n\r\
    \n{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot cookie remove [find user=\$user]\\r\\n/ip hotspot user remove [fin\
    d name=\$user]\\r\\n/ip hotspot active remove [find user=\$user]\\r\\n/sys\
    tem scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}\r\
    \n" parent-queue=Hotspot_Users rate-limit=2M/2M transparent-proxy=yes
/queue tree
add comment="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
    +++++++++++++++++DOWNLOAD-SECTION+++++++++++++++++++++++++++++++++++++++++\
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" name=\
    WAN-DOWNLOAD parent=A.ALL-WAN-CONNECTIONS queue=pcq-download-default
add comment="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
    +++++++++++++++++UPLOAD-SECTION+++++++++++++++++++++++++++++++++++++++++++\
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" name=\
    WAN-UPLOAD parent=A.ALL-WAN-CONNECTIONS queue=pcq-upload-default
add name="2.WAN-PING/ICMP DOWN" packet-mark="ICMP DOWN WAN" parent=WAN-DOWNLOAD priority=2 queue=pcq-download-default
add name="1.WAN-ONLINE GAME DOWN" packet-mark="PORT OTHER THAN PORT GENERAL(GAME) DOWN WAN" parent=WAN-DOWNLOAD priority=1 queue=pcq-download-default
add max-limit=20M name="3.WAN-ALL TRAFFIC DOWN" parent=WAN-DOWNLOAD priority=2 queue=pcq-download-default
add name="a.WAN-GENERAL ALL DOWN" packet-mark="DOWNLOAD ALL WAN" parent="3.WAN-ALL TRAFFIC DOWN" priority=2 queue=pcq-download-default
add name="d.WAN-RANDOM PORT LOAD DOWN" packet-mark="PORT WEIGHT DOWN WAN" parent="3.WAN-ALL TRAFFIC DOWN" priority=2 queue=pcq-download-default
add name="e.WAN-SPEEDTEST PORT DOWN" packet-mark="SPEEDTEST DOWN WAN" parent="3.WAN-ALL TRAFFIC DOWN" priority=2 queue=pcq-download-default
add name="1.WAN-ONLINE GAME UP" packet-mark="PORT OTHER THAN PORT GENERAL(GAME) UP WAN" parent=WAN-UPLOAD priority=1 \queue=pcq-upload-default
add name="2.WAN-PING/ICMP UP" packet-mark="ICMP UP WAN" parent=WAN-UPLOAD priority=2 queue=pcq-upload-default
add max-limit=20M name="3.WAN-ALL TRAFFIC UP" parent=WAN-UPLOAD priority=2 \
    queue=pcq-upload-default
add name="a.WAN-GENERAL ALL UP" packet-mark="UPLOAD ALL WAN" parent=\
    "3.WAN-ALL TRAFFIC UP" priority=2 queue=pcq-upload-default
add name="d.WAN-RANDOM PORT LOAD UP" packet-mark="PORT WEIGHT UP WAN" parent=\
    "3.WAN-ALL TRAFFIC UP" priority=2 queue=pcq-upload-default
add name="e.WAN-SPEEDTEST PORT UP" packet-mark="SPEEDTEST UP WAN" parent=\
    "3.WAN-ALL TRAFFIC UP" priority=2 queue=pcq-upload-default
add name="b.WAN-VIDEO STREAMING DOWN" packet-mark="STREAMING VIDEO DOWN WAN" \
    parent="3.WAN-ALL TRAFFIC DOWN" priority=2 queue=pcq-download-default
add name="b.WAN-VIDEO STREAMING UP" packet-mark="STREAMING VIDEO UP WAN" \
    parent="3.WAN-ALL TRAFFIC UP" priority=2 queue=pcq-upload-default
add max-limit=10M name="c.WAN-GENERAL ALL LOAD DOWN" packet-mark=\
    "GENERAL WEIGHT DOWN WAN" parent="3.WAN-ALL TRAFFIC DOWN" priority=2 \
    queue=pcq-download-default
add max-limit=10M name="c.WAN-GENERAL ALL LOAD UP" packet-mark=\
    "GENERAL WEIGHT UP WAN" parent="3.WAN-ALL TRAFFIC UP" priority=2 queue=\
    pcq-upload-default
/system logging action
set 0 memory-lines=50
set 1 disk-file-count=1 disk-lines-per-file=50
/user group
add name=admin policy="local,telnet,ssh,reboot,read,write,test,winbox,password\
    ,web,sniff,sensitive,api,romon,tikapp,!ftp,!policy,!dude"
/interface bridge port
add bridge=bridge1_local interface=LAN2
add bridge=bridge1_local interface=LAN3
add bridge=bridge2_hotspot interface=HOTSPOT4
add bridge=bridge2_hotspot interface=wlan1
/ip firewall connection tracking
set enabled=yes generic-timeout=5m tcp-established-timeout=5m
/ip address
add address=192.168.88.1/24 interface=bridge1_local network=192.168.88.0
add address=10.10.10.1/24 interface=bridge2_hotspot network=10.10.10.0
add address=192.168.1.21/24 interface=WAN1 network=192.168.1.0
/ip cloud
set update-time=no
/ip dhcp-client
add dhcp-options=hostname,clientid interface=WAN1
/ip dhcp-server network
add address=10.10.10.0/24 comment="hotspot network" gateway=10.10.10.1
add address=192.168.88.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.88.1
/ip dns
set servers=8.8.8.8,8.8.4.4
/ip firewall address-list
add address=10.10.10.0/24 list=LOCAL
add address=192.168.88.0/24 list=LOCAL
add address=192.168.1.0/24 list=EXCEPT
add address=192.168.1.1 list=EXCEPT
add address=192.168.88.0/24 disabled=yes list=EXCEPT
add address=192.168.88.1 disabled=yes list=EXCEPT
/ip firewall filter
add action=accept chain=input comment="wifi vendo" dst-port=8728 protocol=tcp
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=drop chain=forward comment="Drop Invalid " connection-state=\
    invalid
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward comment="Blocked Sites" layer7-protocol=Block
add action=drop chain=forward comment="Pancafe AdBlock" content=\
    go.pancafepro.com
add action=drop chain=forward comment="ADS BLOCKER" layer7-protocol=\
    "ADS BLOCKER"
/ip firewall mangle
add action=mark-connection chain=prerouting dst-address-list=\
    "!IP USE PORT RANDOM" new-connection-mark="TOTAL ALL" passthrough=yes \
    protocol=!icmp src-address-list=LOCAL
add action=mark-packet chain=forward connection-mark="TOTAL ALL" \
    dst-address-list=LOCAL in-interface=WAN1 new-packet-mark=\
    "DOWNLOAD ALL WAN" passthrough=yes protocol=!icmp src-address-list=\
    "!IP USE PORT RANDOM"
add action=mark-packet chain=forward connection-mark="TOTAL ALL" \
    dst-address-list="!IP USE PORT RANDOM" new-packet-mark="UPLOAD ALL WAN" \
    out-interface=WAN1 passthrough=yes protocol=!icmp src-address-list=LOCAL
add action=add-dst-to-address-list address-list="IP USE PORT RANDOM" \
    address-list-timeout=1m chain=prerouting dst-address-list=!EXCEPT \
    dst-port=!21,22,23,81,88,5050,843,182,8777,1935,53,8000-8081,443,80 \
    protocol=tcp src-address-list=LOCAL
add action=add-dst-to-address-list address-list="IP USE PORT RANDOM" \
    address-list-timeout=1m chain=prerouting dst-address-list=!EXCEPT \
    dst-port=!21,22,23,81,88,5050,843,182,8777,1935,53,8000-8081,443,80 \
    protocol=udp src-address-list=LOCAL
add action=mark-packet chain=forward dst-address-list=LOCAL in-interface=WAN1 \
    new-packet-mark="PORT OTHER THAN PORT GENERAL(GAME) DOWN WAN" \
    passthrough=yes src-address-list="IP USE PORT RANDOM"
add action=mark-packet chain=forward dst-address-list="IP USE PORT RANDOM" \
    new-packet-mark="PORT OTHER THAN PORT GENERAL(GAME) UP WAN" \
    out-interface=WAN1 passthrough=yes src-address-list=LOCAL
add action=add-dst-to-address-list address-list="PORT WEIGHT" \
    address-list-timeout=59m chain=prerouting connection-rate=1M-999M \
    dst-address-list="IP USE PORT RANDOM" src-address-list=LOCAL
add action=add-dst-to-address-list address-list="PORT WEIGHT" \
    address-list-timeout=59m chain=prerouting connection-bytes=\
    10000000-999000000 dst-address-list="IP USE PORT RANDOM" \
    src-address-list=LOCAL
add action=mark-packet chain=forward in-interface=WAN1 new-packet-mark=\
    "PORT WEIGHT DOWN WAN" passthrough=yes src-address-list="PORT WEIGHT"
add action=mark-packet chain=forward dst-address-list="PORT WEIGHT" \
    new-packet-mark="PORT WEIGHT UP WAN" out-interface=WAN1 passthrough=yes
add action=mark-connection chain=prerouting new-connection-mark=ICMP \
    passthrough=yes protocol=icmp
add action=mark-packet chain=forward connection-mark=ICMP in-interface=WAN1 \
    new-packet-mark="ICMP DOWN WAN" passthrough=yes
add action=mark-packet chain=forward connection-mark=ICMP new-packet-mark=\
    "ICMP UP WAN" out-interface=WAN1 passthrough=yes
add action=mark-connection chain=prerouting layer7-protocol=speedtest \
    new-connection-mark=speedtest passthrough=no
add action=mark-packet chain=forward connection-mark=speedtest in-interface=\
    WAN1 new-packet-mark="SPEEDTEST DOWN WAN" passthrough=yes
add action=mark-packet chain=forward connection-mark=speedtest \
    new-packet-mark="SPEEDTEST UP WAN" out-interface=WAN1 passthrough=yes
add action=add-dst-to-address-list address-list="GENERAL WEIGHT" \
    address-list-timeout=25s chain=prerouting connection-bytes=\
    5000000-999000000 connection-mark="TOTAL ALL" connection-rate=512k-999M \
    dst-address-list="!PORT WEIGHT" layer7-protocol=!streaming \
    src-address-list=LOCAL
add action=mark-packet chain=forward dst-address-list=LOCAL in-interface=WAN1 \
    layer7-protocol=!streaming new-packet-mark="GENERAL WEIGHT DOWN WAN" \
    passthrough=yes src-address-list="GENERAL WEIGHT"
add action=mark-packet chain=forward dst-address-list="GENERAL WEIGHT" \
    layer7-protocol=!streaming new-packet-mark="GENERAL WEIGHT UP WAN" \
    out-interface=WAN1 passthrough=yes src-address-list=LOCAL
add action=mark-packet chain=forward dst-address-list=LOCAL in-interface=WAN1 \
    layer7-protocol=streaming new-packet-mark="STREAMING VIDEO DOWN WAN" \
    passthrough=yes
add action=mark-packet chain=forward layer7-protocol=streaming \
    new-packet-mark="STREAMING VIDEO UP WAN" out-interface=WAN1 passthrough=\
    yes src-address-list=LOCAL
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface=WAN1
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.10.10.0/24
/ip hotspot ip-binding
add address=10.10.10.100 mac-address=44:D1:FA:8D:F7:31 server=hotspot1 \
    to-address=10.10.10.100 type=bypassed
/ip hotspot user
add name=admin password=123456
add limit-uptime=2h20m name=527918 password=527918 profile=R3 server=hotspot1
add limit-uptime=1h20m name=524914 password=524914 profile=R2 server=hotspot1
/ip hotspot walled-garden
add comment="place hotspot rules here" disabled=yes
/ip hotspot walled-garden ip
add action=accept comment=arc1142gd4ldf378h210 disabled=no dst-port=8728 \
    protocol=tcp server=hotspot1
/ip route
add check-gateway=ping distance=1 gateway=192.168.1.1
/system clock
set time-zone-autodetect=no time-zone-name=Asia/Manila
/system ntp client
set enabled=yes primary-ntp=202.65.114.202 secondary-ntp=212.26.18.41 \
    server-dns-names=asia.poool.ntp.org
/system scheduler
add interval=10m name=Resetter on-event="counter resetter" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=sep/16/2019 start-time=09:45:08
add interval=10m name=QueueTreeResetter on-event=queuetree policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=oct/19/2019 start-time=10:09:25
add interval=10m name="DNS flush" on-event="dns flush" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=sep/16/2019 start-time=09:45:08
add interval=5m name=datetime on-event=":local date [sys clock get date]; \r\
    \n:local time [/sys clock get time]; \r\
    \n/sys scr set source=\"/sys clock set date=\$date time=\$time\" [find whe\
    re name=datetime];" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=jan/30/2020 start-time=02:52:23
add name=datetime-startup on-event="/sys scr run datetime" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=2h20m name=527918 on-event="/ip hotspot cookie remove [find user=\
    527918]\r\
    \n/ip hotspot user remove [find name=527918]\r\
    \n/ip hotspot active remove [find user=527918]\r\
    \n/system scheduler remove [find name=527918]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=may/21/2020 start-time=20:36:33
add interval=1h20m name=524914 on-event="/ip hotspot cookie remove [find user=\
    524914]\r\
    \n/ip hotspot user remove [find name=524914]\r\
    \n/ip hotspot active remove [find user=524914]\r\
    \n/system scheduler remove [find name=524914]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=may/21/2020 start-time=22:29:42
/system script
add dont-require-permissions=no name="counter resetter" owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/\
    ip firewall nat reset-counters-all\r\
    \n/ip firewall mangle reset-counters-all\r\
    \n/ip firewall filter reset-counters-all\r\
    \n/queue simple reset-counters-all\r\
    \n/queue tree reset-counters-all"
add dont-require-permissions=no name=queuetree owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    "/queue tree reset-counters-all"
add dont-require-permissions=no name="dns flush" owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    "/ip dns cache flush"
add dont-require-permissions=no name=datetime owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    "/sys clock set date=may/21/2020 time=22:42:23"
/system watchdog
set watchdog-timer=no
