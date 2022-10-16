
/interface bridge
add name=PPPPOE-HOTSPOT
add name=bridge-local
add name=bridge-management
/interface ethernet
set [ find default-name=ether1 ] comment=ISP
set [ find default-name=ether2 ] comment=Local
set [ find default-name=ether5 ] comment=PPPOE
set [ find default-name=sfp1 ] comment=SFP
/interface vlan
add interface=PPPPOE-HOTSPOT name=vlan-management vlan-id=50
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
add dns-name=urbanlink.net.ph hotspot-address=10.5.50.1 name=hsprof1
/ip hotspot user profile
set [ find default=yes ] on-login="if ([/ip hotspot user get [find name=\$user\
    ] comment]=\"\") do={ /ip hotspot user set [find name=\$user] comment=2}"
add mac-cookie-timeout=1d name="1 Hour" on-login="if ([/ip hotspot user get [f\
    ind name=\$user] comment]=\"\") do={ /ip hotspot user set [find name=\$use\
    r] comment=1}" rate-limit=512k/1m transparent-proxy=yes
add mac-cookie-timeout=1d name="2 Hours" on-login=":local uname \$user;\r\
    \n:local date [/system clock get date];\r\
    \n:local time [/system clock get time];\r\
    \n:log warning \"the \$uname has logged in at \$time\";\r\
    \n{\r\
    \n:if ([/system scheduler find name=\$uname]=\"\") do={\r\
    \n/system scheduler add name=\$uname interval=5h on-event=\"/ip hotspot us\
    er remove [find name=\$uname]\\r\\n/ip hotspot active remove [find user=\$\
    uname]\\r\\n/system scheduler remove [find name=\$uname]\"\r\
    \n}\r\
    \n}" rate-limit=512k/1m transparent-proxy=yes
add mac-cookie-timeout=2d name="5 Hours" on-login="{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot user remove [find name=\$user]\\r\\n/ip hotspot active remove [fin\
    d user=\$user]\\r\\n/system scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}" rate-limit=512k/1m transparent-proxy=yes
add name="1 Day" rate-limit=512k/1m transparent-proxy=yes
add name="7 Days" rate-limit=512k/1m transparent-proxy=yes
add name="1 Month" rate-limit=512k/1m transparent-proxy=yes
add name=unliguest rate-limit=512K/1M
add name=RATE-1 on-login=":local username \$user;\r\
    \n:local date [/system clock get date];\r\
    \n:local time [/system clock get time];\r\
    \n:log warning \"\$username has login - \$time\";  \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$username]=\"\") do={ /ip hotspot use\
    r set [find name=\$user] limit-uptime=1h \r\
    \n/system scheduler add name=\$username interval=1h on-event=\"/ip hotspot\
    \_user remove [find name=\$username]\\r\\n/ip hotspot active remove [find \
    user=\$username]\\r\\n/system scheduler remove [find name=\$username]\"\r\
    \n}\r\
    \n}" rate-limit=512K/1M
add name=RATE-2 on-login=":local uname \$user;\r\
    \n:local date [/system clock get date];\r\
    \n:local time [/system clock get time];\r\
    \n:log warning \"the \$uname has logged in at \$time\";\r\
    \n{\r\
    \n:if ([/system scheduler find name=\$uname]=\"\") do={\r\
    \n/system scheduler add name=\$uname interval=4h on-event=\"/ip hotspot us\
    er remove [find name=\$uname]\\r\\n/ip hotspot active remove [find user=\$\
    uname]\\r\\n/system scheduler remove [find name=\$uname]\"\r\
    \n}\r\
    \n}" rate-limit=512K/1M
add name=RATE-3 on-login=":local uname \$user;\r\
    \n:local date [/system clock get date];\r\
    \n:local time [/system clock get time];\r\
    \n:log warning \"the \$uname has logged in at \$time\";\r\
    \n{\r\
    \n:if ([/system scheduler find name=\$uname]=\"\") do={\r\
    \n/system scheduler add name=\$uname interval=10h on-event=\"/ip hotspot u\
    ser remove [find name=\$uname]\\r\\n/ip hotspot active remove [find user=\
    \$uname]\\r\\n/system scheduler remove [find name=\$uname]\"\r\
    \n}\r\
    \n}" rate-limit=512K/1M
add name=RATE-4 on-login=":local uname \$user;\r\
    \n:local date [/system clock get date];\r\
    \n:local time [/system clock get time];\r\
    \n:log warning \"the \$uname has logged in at \$time\";\r\
    \n{\r\
    \n:if ([/system scheduler find name=\$uname]=\"\") do={\r\
    \n/system scheduler add name=\$uname interval=1d on-event=\"/ip hotspot us\
    er remove [find name=\$uname]\\r\\n/ip hotspot active remove [find user=\$\
    uname]\\r\\n/system scheduler remove [find name=\$uname]\"\r\
    \n}\r\
    \n}" rate-limit=512K/1M
add name=temporaryaccounts rate-limit=1M/2M shared-users=2
add name=VM-0 on-login="{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot user remove [find name=\$user]\\r\\n/ip hotspot active remove [fin\
    d user=\$user]\\r\\n/system scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}" rate-limit=512K/1M transparent-proxy=yes
add name=1-Oras on-login="{ \r\
    \n:local date [/system clock get date]\r\
    \n:local time [/system clock get time]\r\
    \n:local LimitUptime [/ip hotspot user get \$user limit-uptime]; \r\
    \n{\r\
    \n:if ([/system scheduler find name=\$user]=\"\") do={ \r\
    \n/system scheduler add name=\$user interval=\$LimitUptime on-event=\"/ip \
    hotspot user remove [find name=\$user]\\r\\n/ip hotspot active remove [fin\
    d user=\$user]\\r\\n/system scheduler remove [find name=\$user]\"\r\
    \n}\r\
    \n}\r\
    \n}" rate-limit=512K/1M
add name=FreeAcount rate-limit=512K/512K
add name=Monthly2k rate-limit=512K/1M
add name="Monthly2k 3 user" rate-limit=512K/512K shared-users=3
/ip pool
add name=PPPPOE-Pool ranges=172.168.5.2-172.168.5.254
add name=dhcp_pool1 ranges=192.168.5.2-192.168.5.254
add name=hs-pool-13 ranges=10.5.50.2-10.5.50.254
add name=dhcp_pool3 ranges=56.54.1.2-56.54.1.254
/ip dhcp-server
add address-pool=hs-pool-13 disabled=no interface=PPPPOE-HOTSPOT lease-time=\
    1h name=dhcp2
add address-pool=dhcp_pool3 disabled=no interface=bridge-local name=dhcp3
/ip hotspot
add address-pool=hs-pool-13 disabled=no interface=PPPPOE-HOTSPOT name=\
    hotspot1 profile=hsprof1
/ppp profile
set *0 local-address=PPPPOE-Pool remote-address=PPPPOE-Pool
add local-address=PPPPOE-Pool name="Plan 3mbps" rate-limit=1m/4m \
    remote-address=PPPPOE-Pool
add local-address=PPPPOE-Pool name="Plan 5mbps" rate-limit=1m/6m \
    remote-address=PPPPOE-Pool
add local-address=PPPPOE-Pool name="Plan 8mbps" rate-limit=2m/9m \
    remote-address=PPPPOE-Pool
add local-address=PPPPOE-Pool name="Plan 10mbps" rate-limit=2m/11m \
    remote-address=PPPPOE-Pool
add local-address=PPPPOE-Pool name="Plan 20mbps" rate-limit=3m/21m \
    remote-address=PPPPOE-Pool
add local-address=PPPPOE-Pool name="Plan 15mbps" rate-limit=2m/16m \
    remote-address=PPPPOE-Pool
add local-address=PPPPOE-Pool name=disconotice rate-limit=128k/128k \
    remote-address=PPPPOE-Pool
add local-address=PPPPOE-Pool name="Plan 3mbps_sogod" rate-limit=1m/3m \
    remote-address=PPPPOE-Pool
/interface sstp-client
add connect-to=118.27.27.195 disabled=no name=sstp-out1 password=12345 \
    profile=default-encryption user=BAYBAYFIBER
/queue type
add kind=pcq name=pcq-download pcq-classifier=dst-address \
    pcq-dst-address6-mask=64 pcq-src-address6-mask=64 pcq-total-limit=2800KiB
add kind=pcq name=pcq-upload pcq-classifier=src-address \
    pcq-dst-address6-mask=64 pcq-rate=128k pcq-src-address6-mask=64 \
    pcq-total-limit=512KiB
add kind=pcq name=pcq-streaming-down pcq-classifier=dst-address \
    pcq-dst-address6-mask=64 pcq-src-address6-mask=64
add kind=pcq name=pcq-streaming-up pcq-classifier=dst-address \
    pcq-dst-address6-mask=64 pcq-rate=128k pcq-src-address6-mask=64
add kind=pcq name=ping_pkts_i_32K pcq-classifier=dst-address \
    pcq-dst-address6-mask=64 pcq-rate=32k pcq-src-address6-mask=64
add kind=pcq name=ping_pkts_o_32K pcq-classifier=src-address \
    pcq-dst-address6-mask=64 pcq-rate=32k pcq-src-address6-mask=64
add kind=pcq name=pcq-extDL pcq-classifier=dst-address pcq-dst-address6-mask=\
    64 pcq-src-address6-mask=64
/queue tree
add limit-at=1M max-limit=1M name=ICMP packet-mark=ping_pkts_i parent=global \
    queue=default
add limit-at=1M max-limit=1M name=O_ICMP packet-mark=ping_pkts_o parent=\
    global queue=default
/user group
add name=group1 policy="telnet,reboot,read,write,policy,winbox,password,web,ap\
    i,!local,!ssh,!ftp,!test,!sniff,!sensitive,!romon,!dude,!tikapp"
add name=group2 policy="reboot,read,write,winbox,password,web,!local,!telnet,!\
    ssh,!ftp,!policy,!test,!sniff,!sensitive,!api,!romon,!dude,!tikapp"
add name=flexifipro policy="telnet,write,!local,!ssh,!ftp,!reboot,!read,!polic\
    y,!test,!winbox,!password,!web,!sniff,!sensitive,!api,!romon,!dude,!tikapp\
    "
/interface bridge port
add bridge=bridge-local interface=ether2
add bridge=bridge-local interface=ether3
add bridge=PPPPOE-HOTSPOT interface=ether5
add bridge=PPPPOE-HOTSPOT interface=ether6
add bridge=PPPPOE-HOTSPOT interface=ether7
add bridge=PPPPOE-HOTSPOT interface=ether8
add bridge=PPPPOE-HOTSPOT interface=ether9
add bridge=PPPPOE-HOTSPOT interface=ether10
add bridge=bridge-local interface=sfp1
add bridge=bridge-local interface=ether4
add bridge=bridge-management interface=vlan-management
/interface pppoe-server server
add disabled=no interface=PPPPOE-HOTSPOT max-mru=1450 max-mtu=1450 mrru=1500 \
    service-name=PPPOE-service
/ip address
add address=10.5.50.1/24 comment="hotspot network" interface=PPPPOE-HOTSPOT \
    network=10.5.50.0
add address=56.54.1.1/24 interface=bridge-local network=56.54.1.0
/ip dhcp-client
add dhcp-options=hostname,clientid disabled=no interface=ether1
/ip dhcp-server network
add address=10.5.50.0/24 comment="hotspot network" gateway=10.5.50.1
add address=56.54.1.0/24 gateway=56.54.1.1
add address=192.168.5.0/24 gateway=192.168.5.1
/ip dns
set allow-remote-requests=yes cache-size=5000KiB max-udp-packet-size=512 \
    servers=8.8.8.8,8.8.4.4
/ip firewall address-list
add address=63.150.138.0/24 comment="Dota 2" list=games
add address=103.10.124.0/24 comment="Dota 2" list=games
add address=103.28.54.0/23 comment="Dota 2" list=games
add address=146.66.152.0/23 comment="Dota 2" list=games
add address=146.66.154.0/24 comment="Dota 2" list=games
add address=146.66.156.0/23 comment="Dota 2" list=games
add address=146.66.158.0/23 comment="Dota 2" list=games
add address=185.25.180.0/23 comment="Dota 2" list=games
add address=185.25.182.0/24 comment="Dota 2" list=games
add address=192.69.96.0/22 comment="Dota 2" list=games
add address=205.196.6.0/24 comment="Dota 2" list=games
add address=208.64.200.0/24 comment="Dota 2" list=games
add address=208.64.201.0/24 comment="Dota 2" list=games
add address=208.64.202.0/24 comment="Dota 2" list=games
add address=208.64.203.0/24 comment="Dota 2" list=games
add address=208.78.164.0/22 comment="Dota 2" list=games
add address=216.111.123.0/24 comment="Dota 2" list=games
add address=125.5.3.0/24 comment="LoL Phil" list=games
add address=31.186.224.0/24 comment="LoL Europe" list=games
add address=31.186.226.0/24 comment="LoL Europe" list=games
add address=64.7.194.0/24 comment="LoL Europe" list=games
add address=95.172.65.0/24 comment="LoL Europe" list=games
add address=95.172.70.0/24 comment="LoL Europe" list=games
add address=66.150.148.0/24 comment="LoL EU-NE" list=games
add address=192.64.168.0/24 comment="LoL NA" list=games
add address=192.64.169.0/24 comment="LoL NA" list=games
add address=192.64.170.0/24 comment="LoL NA" list=games
add address=216.133.234.0/24 comment="LoL NA" list=games
add address=59.100.95.128/25 comment="LoL Oceania" list=games
add address=203.116.112.128/25 comment="LoL Singapore/Malaysia" list=games
add address=56.54.1.0/24 list=myip
add address=10.5.50.0/24 list=myip
add address=172.168.5.0/24 list=myip
add address=155.133.253.0/24 comment=Dota2 list=games
add address=0.0.0.0/8 comment="RFC 1122 \"This host on this network\"" list=\
    Bogons
add address=10.0.0.0/8 comment="RFC 1918 (Private Use IP Space)" list=Bogons
add address=100.64.0.0/10 comment="RFC 6598 (Shared Address Space)" list=\
    Bogons
add address=127.0.0.0/8 comment="RFC 1122 (Loopback)" list=Bogons
add address=169.254.0.0/16 comment=\
    "RFC 3927 (Dynamic Configuration of IPv4 Link-Local Addresses)" list=\
    Bogons
add address=172.16.0.0/12 comment="RFC 1918 (Private Use IP Space)" list=\
    Bogons
add address=192.0.0.0/24 comment="RFC 6890 (IETF Protocol Assingments)" list=\
    Bogons
add address=192.0.2.0/24 comment="RFC 5737 (Test-Net-1)" list=Bogons
add address=192.168.0.0/16 comment="RFC 1918 (Private Use IP Space)" list=\
    Bogons
add address=198.18.0.0/15 comment="RFC 2544 (Benchmarking)" list=Bogons
add address=198.51.100.0/24 comment="RFC 5737 (Test-Net-2)" list=Bogons
add address=203.0.113.0/24 comment="RFC 5737 (Test-Net-3)" list=Bogons
add address=224.0.0.0/4 comment="RFC 5771 (Multicast Addresses) - Will affect \
    OSPF, RIP, PIM, VRRP, IS-IS, and others. Use with caution.)" list=Bogons
add address=240.0.0.0/4 comment="RFC 1112 (Reserved)" list=Bogons
add address=192.31.196.0/24 comment="RFC 7535 (AS112-v4)" list=Bogons
add address=192.52.193.0/24 comment="RFC 7450 (AMT)" list=Bogons
add address=192.88.99.0/24 comment=\
    "RFC 7526 (Deprecated (6to4 Relay Anycast))" list=Bogons
add address=192.175.48.0/24 comment=\
    "RFC 7534 (Direct Delegation AS112 Service)" list=Bogons
add address=255.255.255.255 comment="RFC 919 (Limited Broadcast)" list=Bogons
/ip firewall filter
add action=drop chain=hs-unauth comment="Black  list Mac" src-mac-address=\
    AC:FE:05:98:A5:2B
add action=drop chain=hs-unauth disabled=yes src-mac-address=\
    C0:2E:25:5B:76:61
add action=drop chain=hs-unauth disabled=yes src-mac-address=\
    00:08:22:FA:CD:32
add action=accept chain=hs-unauth comment=Accepted dst-port=53,23 protocol=\
    tcp
add action=accept chain=hs-unauth protocol=icmp
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=drop chain=input disabled=yes dst-address-list=connected \
    src-address-list=PPPoE
add action=drop chain=forward disabled=yes dst-address-list=connected \
    src-address-list=PPPoE
add action=drop chain=input comment="Drop Invalid Connections" \
    connection-state=invalid
add action=drop chain=forward comment="Drop Invalid Connections" \
    connection-state=invalid
add action=accept chain=input comment="Accept Exempt IP Addresses" \
    src-address-list="Exempt Addresses"
add action=accept chain=forward comment="Accept Exempt IP Addresses" \
    src-address-list="Exempt Addresses"
add action=drop chain=input comment=\
    "Drop anyone in the Black List (Manually Added)" src-address-list=\
    "Black List"
add action=drop chain=forward comment=\
    "Drop anyone in the Black List (Manually Added)" src-address-list=\
    "Black List"
add action=drop chain=input comment="Drop anyone in the Black List (SSH)" \
    src-address-list="Black List (SSH)"
add action=drop chain=forward comment="Drop anyone in the Black List (SSH)" \
    src-address-list="Black List (SSH)"
add action=drop chain=input comment="Drop anyone in the Black List (Telnet)" \
    src-address-list="Black List (Telnet)"
add action=drop chain=forward comment=\
    "Drop anyone in the Black List (Telnet)" src-address-list=\
    "Black List (Telnet)"
add action=drop chain=input comment="Drop anyone in the Black List (Winbox)" \
    src-address-list="Black List (Winbox)"
add action=drop chain=forward comment=\
    "Drop anyone in the Black List (Winbox)" src-address-list=\
    "Black List (Winbox)"
add action=drop chain=input comment=\
    "Drop anyone in the WAN Port Scanner List" src-address-list=\
    "WAN Port Scanners"
add action=drop chain=forward comment=\
    "Drop anyone in the WAN Port Scanner List" disabled=yes src-address-list=\
    "WAN Port Scanners"
add action=drop chain=input comment=\
    "Drop anyone in the LAN Port Scanner List" src-address-list=\
    "LAN Port Scanners"
add action=drop chain=forward comment=\
    "Drop anyone in the LAN Port Scanner List" disabled=yes src-address-list=\
    "LAN Port Scanners"
add action=drop chain=input comment="Drop all Bogons" disabled=yes \
    src-address-list=Bogons
add action=drop chain=forward comment="Drop all Bogons" disabled=yes \
    src-address-list=Bogons
add action=drop chain=forward comment="Drop all P2P" disabled=yes p2p=all-p2p
add chain=output comment="Section Break" disabled=yes
add action=jump chain=input comment="Jump to RFC SSH Chain" jump-target=\
    "RFC SSH Chain"
add action=add-src-to-address-list address-list="Black List (SSH)" \
    address-list-timeout=none-dynamic chain="RFC SSH Chain" comment=\
    "Transfer repeated attempts from SSH Stage 3 to Black-List" \
    connection-state=new dst-port=22 protocol=tcp src-address-list=\
    "SSH Stage 3"
add action=add-src-to-address-list address-list="SSH Stage 3" \
    address-list-timeout=1m chain="RFC SSH Chain" comment=\
    "Add succesive attempts to SSH Stage 3" connection-state=new dst-port=22 \
    protocol=tcp src-address-list="SSH Stage 2"
add action=add-src-to-address-list address-list="SSH Stage 2" \
    address-list-timeout=1m chain="RFC SSH Chain" comment=\
    "Add succesive attempts to SSH Stage 2" connection-state=new dst-port=22 \
    protocol=tcp src-address-list="SSH Stage 1"
add action=add-src-to-address-list address-list="SSH Stage 1" \
    address-list-timeout=1m chain="RFC SSH Chain" comment=\
    "Add intial attempt to SSH Stage 1 List" connection-state=new dst-port=22 \
    protocol=tcp
add action=return chain="RFC SSH Chain" comment="Return From RFC SSH Chain"
add chain=output comment="Section Break" disabled=yes
add action=jump chain=input comment="Jump to RFC Telnet Chain" jump-target=\
    "RFC Telnet Chain"
add action=add-src-to-address-list address-list="Black List (Telnet)" \
    address-list-timeout=none-dynamic chain="RFC Telnet Chain" comment=\
    "Transfer repeated attempts from Telnet Stage 3 to Black-List" \
    connection-state=new dst-port=23 protocol=tcp src-address-list=\
    "Telnet Stage 3"
add action=add-src-to-address-list address-list="Telnet Stage 3" \
    address-list-timeout=1m chain="RFC Telnet Chain" comment=\
    "Add succesive attempts to Telnet Stage 3" connection-state=new dst-port=\
    23 protocol=tcp src-address-list="Telnet Stage 2"
add action=add-src-to-address-list address-list="Telnet Stage 2" \
    address-list-timeout=1m chain="RFC Telnet Chain" comment=\
    "Add succesive attempts to Telnet Stage 2" connection-state=new dst-port=\
    23 protocol=tcp src-address-list="Telnet Stage 1"
add action=add-src-to-address-list address-list="Telnet Stage 1" \
    address-list-timeout=1m chain="RFC Telnet Chain" comment=\
    "Add Intial attempt to Telnet Stage 1" connection-state=new dst-port=23 \
    protocol=tcp
add action=return chain="RFC Telnet Chain" comment=\
    "Return From RFC Telnet Chain"
add chain=output comment="Section Break" disabled=yes
add action=jump chain=input comment="Jump to RFC Winbox Chain" jump-target=\
    "RFC Winbox Chain"
add action=add-src-to-address-list address-list="Black List (Winbox)" \
    address-list-timeout=none-dynamic chain="RFC Winbox Chain" comment=\
    "Transfer repeated attempts from Winbox Stage 3 to Black-List" \
    connection-state=new dst-port=8295 protocol=tcp src-address-list=\
    "Winbox Stage 3"
add action=add-src-to-address-list address-list="Winbox Stage 3" \
    address-list-timeout=1m chain="RFC Winbox Chain" comment=\
    "Add succesive attempts to Winbox Stage 3" connection-state=new dst-port=\
    8295 protocol=tcp src-address-list="Winbox Stage 2"
add action=add-src-to-address-list address-list="Winbox Stage 2" \
    address-list-timeout=1m chain="RFC Winbox Chain" comment=\
    "Add succesive attempts to Winbox Stage 2" connection-state=new dst-port=\
    8295 protocol=tcp src-address-list="Winbox Stage 1"
add action=add-src-to-address-list address-list="Winbox Stage 1" \
    address-list-timeout=1m chain="RFC Winbox Chain" comment=\
    "Add Intial attempt to Winbox Stage 1" connection-state=new dst-port=8295 \
    protocol=tcp
add action=return chain="RFC Winbox Chain" comment=\
    "Return From RFC Winbox Chain"
add chain=output comment="Section Break" disabled=yes
add action=add-src-to-address-list address-list="Wan Port Scanners" chain=\
    input comment="Add TCP Port Scanners to Address List" protocol=tcp psd=\
    40,3s,2,1
add action=add-src-to-address-list address-list="LAN Port Scanners" chain=\
    forward comment="Add TCP Port Scanners to Address List" protocol=tcp psd=\
    40,3s,2,1
add chain=output comment="Section Break" disabled=yes
add action=add-src-to-address-list address-list="(WAN High Connection Rates)" \
    chain=input comment="Add WAN High Connections to Address List" \
    connection-limit=100,32 protocol=tcp
add action=add-src-to-address-list address-list="(LAN High Connection Rates)" \
    address-list-timeout=none-dynamic chain=forward comment=\
    "Add LAN High Connections to Address List" connection-limit=100,32 \
    disabled=yes protocol=tcp
add action=jump chain=input comment="Jump to Virus Chain" jump-target=Virus
add action=drop chain=Virus comment="Drop Blaster Worm" dst-port=135-139 \
    protocol=tcp
add action=drop chain=Virus comment="Drop Blaster Worm" dst-port=445 \
    protocol=tcp
add action=drop chain=Virus comment="Drop Blaster Worm" dst-port=445 \
    protocol=udp
add action=drop chain=Virus comment="Drop Messenger Worm" dst-port=135-139 \
    protocol=udp
add action=drop chain=Virus comment=Conficker dst-port=593 protocol=tcp
add action=drop chain=Virus comment=Worm dst-port=1024-1030 protocol=tcp
add action=drop chain=Virus comment="ndm requester" dst-port=1363 protocol=\
    tcp
add action=drop chain=Virus comment="ndm server" dst-port=1364 protocol=tcp
add action=drop chain=Virus comment="screen cast" dst-port=1368 protocol=tcp
add action=drop chain=Virus comment=hromgrafx dst-port=1373 protocol=tcp
add action=drop chain=Virus comment="Drop MyDoom" dst-port=1080 protocol=tcp
add action=drop chain=Virus comment=cichlid dst-port=1377 protocol=tcp
add action=drop chain=Virus comment=Worm dst-port=1433-1434 protocol=tcp
add action=drop chain=Virus comment="Drop Dumaru.Y" dst-port=2283 protocol=\
    tcp
add action=drop chain=Virus comment="Drop Beagle" dst-port=2535 protocol=tcp
add action=drop chain=Virus comment="Drop Beagle.C-K" dst-port=2745 protocol=\
    tcp
add action=drop chain=Virus comment="Drop MyDoom" dst-port=3127-3128 \
    protocol=tcp
add action=drop chain=Virus comment="Drop Backdoor OptixPro" dst-port=3410 \
    protocol=tcp
add action=drop chain=Virus comment="Drop Sasser" dst-port=5554 protocol=tcp
add action=drop chain=Virus comment=Worm dst-port=4444 protocol=tcp
add action=drop chain=Virus comment=Worm dst-port=4444 protocol=udp
add action=drop chain=Virus comment="Drop Beagle.B" dst-port=8866 protocol=\
    tcp
add action=drop chain=Virus comment="Drop Dabber.A-B" dst-port=9898 protocol=\
    tcp
add action=drop chain=Virus comment="Drop Dumaru.Y" dst-port=10000 protocol=\
    tcp
add action=drop chain=Virus comment="Drop MyDoom.B" dst-port=10080 protocol=\
    tcp
add action=drop chain=Virus comment="Drop NetBus" dst-port=12345 protocol=tcp
add action=drop chain=Virus comment="Drop Kuang2" dst-port=17300 protocol=tcp
add action=drop chain=Virus comment="Drop SubSeven" dst-port=27374 protocol=\
    tcp
add action=drop chain=Virus comment="Drop PhatBot, Agobot, Gaobot" dst-port=\
    65506 protocol=tcp
add action=return chain=Virus comment="Return From Virus Chain"
add chain=output comment="Section Break" disabled=yes
add action=jump chain=forward comment="Jump to \"Manage Common Ports\" Chain" \
    jump-target="Manage Common Ports"
add chain="Manage Common Ports" comment=\
    "\"All hosts on this subnet\" Broadcast" src-address=224.0.0.1
add chain="Manage Common Ports" comment=\
    "\"All routers on this subnet\" Broadcast" src-address=224.0.0.2
add chain="Manage Common Ports" comment=\
    "DVMRP (Distance Vector Multicast Routing Protocol)" src-address=\
    224.0.0.4
add chain="Manage Common Ports" comment="OSPF - All OSPF Routers Broadcast" \
    src-address=224.0.0.5
add chain="Manage Common Ports" comment="OSPF - OSPF DR Routers Broadcast" \
    src-address=224.0.0.6
add chain="Manage Common Ports" comment="RIP Broadcast" src-address=224.0.0.9
add chain="Manage Common Ports" comment="EIGRP Broadcast" src-address=\
    224.0.0.10
add chain="Manage Common Ports" comment="PIM Broadcast" src-address=\
    224.0.0.13
add chain="Manage Common Ports" comment="VRRP Broadcast" src-address=\
    224.0.0.18
add chain="Manage Common Ports" comment="IS-IS Broadcast" src-address=\
    224.0.0.19
add chain="Manage Common Ports" comment="IS-IS Broadcast" src-address=\
    224.0.0.20
add chain="Manage Common Ports" comment="IS-IS Broadcast" src-address=\
    224.0.0.21
add chain="Manage Common Ports" comment="IGMP Broadcast" src-address=\
    224.0.0.22
add chain="Manage Common Ports" comment="GRE Protocol (Local Management)" \
    protocol=gre
add chain="Manage Common Ports" comment="FTPdata transfer" port=20 protocol=\
    tcp
add chain="Manage Common Ports" comment="FTPdata transfer  " port=20 \
    protocol=udp
add chain="Manage Common Ports" comment="FTPcontrol (command)" port=21 \
    protocol=tcp
add chain="Manage Common Ports" comment="Secure Shell(SSH)" port=22 protocol=\
    tcp
add chain="Manage Common Ports" comment="Secure Shell(SSH)   " port=22 \
    protocol=udp
add chain="Manage Common Ports" comment=Telnet port=23 protocol=tcp
add chain="Manage Common Ports" comment=Telnet port=23 protocol=udp
add chain="Manage Common Ports" comment="Priv-mail: any privatemailsystem." \
    port=24 protocol=tcp
add chain="Manage Common Ports" comment="Priv-mail: any privatemailsystem.  " \
    port=24 protocol=udp
add chain="Manage Common Ports" comment="Simple Mail Transfer Protocol(SMTP)" \
    port=25 protocol=tcp
add chain="Manage Common Ports" comment=\
    "Simple Mail Transfer Protocol(SMTP)  " port=25 protocol=udp
add chain="Manage Common Ports" comment="TIME protocol" port=37 protocol=tcp
add chain="Manage Common Ports" comment="TIME protocol  " port=37 protocol=\
    udp
add chain="Manage Common Ports" comment=\
    "ARPA Host Name Server Protocol & WINS" port=42 protocol=tcp
add chain="Manage Common Ports" comment=\
    "ARPA Host Name Server Protocol  & WINS  " port=42 protocol=udp
add chain="Manage Common Ports" comment="WHOIS protocol" port=43 protocol=tcp
add chain="Manage Common Ports" comment="WHOIS protocol" port=43 protocol=udp
add chain="Manage Common Ports" comment="Domain Name System (DNS)" port=53 \
    protocol=tcp
add chain="Manage Common Ports" comment="Domain Name System (DNS)" port=53 \
    protocol=udp
add chain="Manage Common Ports" comment="Mail Transfer Protocol(RFC 780)" \
    port=57 protocol=tcp
add chain="Manage Common Ports" comment="(BOOTP) Server & (DHCP)  " port=67 \
    protocol=udp
add chain="Manage Common Ports" comment="(BOOTP) Client & (DHCP)  " port=68 \
    protocol=udp
add chain="Manage Common Ports" comment=\
    "Trivial File Transfer Protocol (TFTP)  " port=69 protocol=udp
add chain="Manage Common Ports" comment="Gopher protocol" port=70 protocol=\
    tcp
add chain="Manage Common Ports" comment="Finger protocol" port=79 protocol=\
    tcp
add chain="Manage Common Ports" comment="Hypertext Transfer Protocol (HTTP)" \
    port=80 protocol=tcp
add chain="Manage Common Ports" comment="RemoteTELNETService protocol" port=\
    107 protocol=tcp
add chain="Manage Common Ports" comment="Post Office Protocolv2 (POP2)" port=\
    109 protocol=tcp
add chain="Manage Common Ports" comment="Post Office Protocolv3 (POP3)" port=\
    110 protocol=tcp
add chain="Manage Common Ports" comment=\
    "IdentAuthentication Service/Identification Protocol" port=113 protocol=\
    tcp
add chain="Manage Common Ports" comment="Authentication Service (auth)  " \
    port=113 protocol=udp
add chain="Manage Common Ports" comment=\
    "Simple File Transfer Protocol (SFTP)" port=115 protocol=tcp
add chain="Manage Common Ports" comment="Network Time Protocol(NTP)" port=123 \
    protocol=udp
add chain="Manage Common Ports" comment="NetBIOSNetBIOS Name Service" port=\
    137 protocol=tcp
add chain="Manage Common Ports" comment="NetBIOSNetBIOS Name Service  " port=\
    137 protocol=udp
add chain="Manage Common Ports" comment="NetBIOSNetBIOS Datagram Service" \
    port=138 protocol=tcp
add chain="Manage Common Ports" comment="NetBIOSNetBIOS Datagram Service  " \
    port=138 protocol=udp
add chain="Manage Common Ports" comment="NetBIOSNetBIOS Session Service" \
    port=139 protocol=tcp
add chain="Manage Common Ports" comment="NetBIOSNetBIOS Session Service  " \
    port=139 protocol=udp
add chain="Manage Common Ports" comment=\
    "Internet Message Access Protocol (IMAP)" port=143 protocol=tcp
add chain="Manage Common Ports" comment=\
    "Background File Transfer Program (BFTP)" port=152 protocol=tcp
add chain="Manage Common Ports" comment=\
    "Background File Transfer Program (BFTP)  " port=152 protocol=udp
add chain="Manage Common Ports" comment=\
    "SGMP,Simple Gateway Monitoring Protocol" port=153 protocol=tcp
add chain="Manage Common Ports" comment=\
    "SGMP,Simple Gateway Monitoring Protocol  " port=153 protocol=udp
add chain="Manage Common Ports" comment=\
    "DMSP, Distributed Mail Service Protocol" port=158 protocol=tcp
add chain="Manage Common Ports" comment=\
    "DMSP, Distributed Mail Service Protocol  " port=158 protocol=udp
add chain="Manage Common Ports" comment=\
    "Simple Network Management Protocol(SNMP)  " port=161 protocol=udp
add chain="Manage Common Ports" comment=\
    "Simple Network Management ProtocolTrap (SNMPTRAP)" port=162 protocol=tcp
add chain="Manage Common Ports" comment=\
    "Simple Network Management ProtocolTrap (SNMPTRAP)  " port=162 protocol=\
    udp
add chain="Manage Common Ports" comment="BGP (Border Gateway Protocol)" port=\
    179 protocol=tcp
add chain="Manage Common Ports" comment=\
    "Internet Message Access Protocol (IMAP), version 3" port=220 protocol=\
    tcp
add chain="Manage Common Ports" comment=\
    "Internet Message Access Protocol (IMAP), version 3" port=220 protocol=\
    udp
add chain="Manage Common Ports" comment=\
    "BGMP, Border Gateway Multicast Protocol" port=264 protocol=tcp
add chain="Manage Common Ports" comment=\
    "BGMP, Border Gateway Multicast Protocol  " port=264 protocol=udp
add chain="Manage Common Ports" comment=\
    "Lightweight Directory Access Protocol (LDAP)" port=389 protocol=tcp
add chain="Manage Common Ports" comment=\
    "Lightweight Directory Access Protocol (LDAP)" port=389 protocol=udp
add chain="Manage Common Ports" comment=\
    "SSTP TCP Port 443 (Local Management) & HTTPS" port=443 protocol=tcp
add chain="Manage Common Ports" comment=\
    "Microsoft-DSActive Directory, Windows shares" port=445 protocol=tcp
add chain="Manage Common Ports" comment=\
    "L2TP/ IPSEC UDP Port 500 (Local Management)" port=500 protocol=udp
add chain="Manage Common Ports" comment="Modbus, Protocol" port=502 protocol=\
    tcp
add chain="Manage Common Ports" comment="Modbus, Protocol  " port=502 \
    protocol=udp
add chain="Manage Common Ports" comment="Shell (Remote Shell, rsh, remsh)" \
    port=514 protocol=tcp
add chain="Manage Common Ports" comment="Syslog - used for system logging  " \
    port=514 protocol=udp
add chain="Manage Common Ports" comment=\
    "Routing Information Protocol (RIP)  " port=520 protocol=udp
add chain="Manage Common Ports" comment="e-mail message submission (SMTP)" \
    port=587 protocol=tcp
add chain="Manage Common Ports" comment="LDP,Label Distribution Protocol" \
    port=646 protocol=tcp
add chain="Manage Common Ports" comment="LDP,Label Distribution Protocol" \
    port=646 protocol=udp
add chain="Manage Common Ports" comment=\
    "FTPS Protocol (data):FTP over TLS/SSL" port=989 protocol=tcp
add chain="Manage Common Ports" comment=\
    "FTPS Protocol (data):FTP over TLS/SSL" port=989 protocol=udp
add chain="Manage Common Ports" comment=\
    "FTPS Protocol (control):FTP over TLS/SSL" port=990 protocol=tcp
add chain="Manage Common Ports" comment=\
    "FTPS Protocol (control):FTP over TLS/SSL" port=990 protocol=udp
add chain="Manage Common Ports" comment="TELNET protocol overTLS/SSL" port=\
    992 protocol=tcp
add chain="Manage Common Ports" comment="TELNET protocol overTLS/SSL" port=\
    992 protocol=udp
add chain="Manage Common Ports" comment=\
    "Internet Message Access Protocol over TLS/SSL (IMAPS)" port=993 \
    protocol=tcp
add chain="Manage Common Ports" comment=\
    "Post Office Protocol3 over TLS/SSL (POP3S)" port=995 protocol=tcp
add chain="Manage Common Ports" comment=\
    "OVPN TCP Port 1194 (Local Management)" port=1194 protocol=tcp
add chain="Manage Common Ports" comment="PPTP Port 1723 (Local Management)" \
    port=1723 protocol=tcp
add chain="Manage Common Ports" comment=\
    "L2TP UDP Port 1701 (Local Management)" port=1701 protocol=udp
add chain="Manage Common Ports" comment=\
    "L2TP UDP Port 4500 (Local Management)" port=4500 protocol=udp
add chain=input comment="Accept Related or Established Connections" \
    connection-state=established,related disabled=yes
add chain=forward comment="Accept New Connections" connection-state=new \
    disabled=yes
add chain=forward comment="Accept Related or Established Connections" \
    connection-state=established,related disabled=yes
add action=drop chain=forward comment="Drop all other LAN Traffic" disabled=\
    yes
add action=drop chain=input comment="Drop all other WAN Traffic" disabled=yes

#firewall mangle
/ip firewall mangle
add action=change-ttl chain=postrouting comment="change ttl to1" new-ttl=\
    set:1 out-interface=PPPPOE-HOTSPOT
add action=accept chain=prerouting dst-address-list=myip log-prefix=1 \
    src-address-list=myip
add action=mark-connection chain=prerouting comment=Download layer7-protocol=\
    Ext new-connection-mark=Download
add action=mark-connection chain=prerouting connection-bytes=1000000-0 \
    new-connection-mark=Download protocol=tcp src-port=80,443,21
add action=mark-packet chain=prerouting connection-mark=Download \
    new-packet-mark=Download passthrough=no
add action=mark-connection chain=prerouting comment=Streaming \
    layer7-protocol=Streaming new-connection-mark="Video Stream"
add action=mark-packet chain=prerouting connection-mark="Video Stream" \
    new-packet-mark=Youtube passthrough=no
add action=mark-connection chain=prerouting comment=Facebook layer7-protocol=\
    Facebook new-connection-mark=Facebook
add action=mark-packet chain=prerouting connection-mark=Facebook \
    new-packet-mark=Facebook passthrough=no
add action=mark-connection chain=prerouting comment=Browse connection-bytes=\
    0-1000000 new-connection-mark=Browse passthrough=yes protocol=tcp \
    src-port=80,1935,8080,443,5222,5228,59097
add action=mark-connection chain=prerouting new-connection-mark=Browse \
    passthrough=yes protocol=udp src-port=80,1935,8080,443,5222,5228,59097
add action=mark-packet chain=prerouting connection-mark=Browse \
    new-packet-mark=Browse passthrough=no
add action=mark-packet chain=prerouting comment=\
    "=============DNS============" new-packet-mark=dns-conn packet-size=40 \
    passthrough=no protocol=tcp tcp-flags=ack
add action=mark-packet chain=prerouting dst-port=53 new-packet-mark=dns-conn \
    passthrough=no protocol=udp
add action=set-priority chain=prerouting comment=\
    "PRIORITY GAME TRAFFIC UDP AND TCP PORT" connection-mark=gaming \
    dst-address-list=games new-priority=1 passthrough=yes
add action=mark-connection chain=prerouting dst-port=1119 \
    new-connection-mark=gaming protocol=udp
add action=mark-connection chain=prerouting dst-port=1120,3724 \
    new-connection-mark=gaming protocol=udp
add action=mark-connection chain=prerouting dst-port=5000-5500 \
    new-connection-mark=gaming protocol=udp
add action=mark-connection chain=prerouting dst-port=6112-6113 \
    new-connection-mark=gaming protocol=udp
add action=mark-connection chain=prerouting comment=TCP dst-port=\
    2099,5223,5222 new-connection-mark=gaming protocol=tcp
add action=mark-connection chain=prerouting dst-port=9110 \
    new-connection-mark=gaming protocol=tcp
add action=mark-connection chain=prerouting dst-port=16666 \
    new-connection-mark=gaming protocol=tcp
add action=mark-packet chain=prerouting connection-mark=gaming \
    new-packet-mark=gaming passthrough=no
add action=mark-connection chain=prerouting comment=SF1 dst-port=\
    20000-21000,27935 new-connection-mark=gaming passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=27930-27931 \
    new-connection-mark=gaming passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment="SF BULL" dst-port=\
    22001-22999 new-connection-mark=gaming passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=27230-27235 \
    new-connection-mark=gaming passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=Garena dst-port=\
    2099,9100,9200,30000 new-connection-mark=gaming protocol=tcp
add action=mark-connection chain=prerouting dst-port=9110 \
    new-connection-mark=gaming protocol=tcp
add action=mark-connection chain=prerouting dst-port=999,7456-7459,8687-8688 \
    new-connection-mark=gaming protocol=tcp
add action=mark-connection chain=prerouting dst-port=21900,1513-1522,18080 \
    new-connection-mark=gaming protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=gaming \
    protocol=udp src-port=1513-1522
add action=mark-connection chain=forward new-connection-mark=gaming protocol=\
    udp src-port=1513
add action=mark-connection chain=forward dst-port=1513 new-connection-mark=\
    gaming protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    4000-4200,53299,54397,59642 new-connection-mark=gaming protocol=udp
add action=mark-connection chain=prerouting dst-port=49579,53261,41000 \
    new-connection-mark=gaming protocol=udp
add action=mark-connection chain=prerouting comment="Conquer Online" \
    dst-port=5816 new-connection-mark=gaming passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=5816,9528,9958 \
    new-connection-mark=gaming passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=5355 \
    new-connection-mark=gaming passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=9528,9958 \
    new-connection-mark=gaming passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment="DOTA 2" \
    dst-address-list=games dst-port=27000-27060 new-connection-mark=gaming \
    passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    8005-8010,9068,1293,1476,9401,9600,30000 new-connection-mark=gaming \
    protocol=udp
add action=mark-connection chain=prerouting dst-address-list=games dst-port=\
    27005-27020,13055,7800-7900,12060,12070 new-connection-mark=gaming \
    passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    14009-14030,42051-42052,40000-40050,13000-13080 new-connection-mark=\
    gaming protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=gaming \
    protocol=udp src-port=27015-28999
add action=mark-connection chain=prerouting dst-address-list=games dst-port=\
    27015-28999 new-connection-mark=gaming passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-address-list=games dst-port=\
    27026,27050 new-connection-mark=gaming passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=ROS dst-port=\
    24000-25999,5500-5599 new-connection-mark=gaming passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=9000-9100 \
    new-connection-mark=gaming passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=Coc dst-port=9330-9340 \
    new-connection-mark=gaming passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=9330-9340 \
    new-connection-mark=gaming passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Point Blank" dst-port=\
    39190 new-connection-mark=gaming protocol=tcp
add action=mark-connection chain=prerouting dst-port=29890,40003-40007 \
    new-connection-mark=gaming protocol=udp
add action=mark-packet chain=prerouting comment="Mark ICMP I / Hersan" \
    new-packet-mark=ping_pkts_i passthrough=yes protocol=icmp
add action=mark-packet chain=postrouting comment="Mark ICMP O / Hersan" \
    new-packet-mark=ping_pkts_o passthrough=yes protocol=icmp
add action=mark-connection chain=prerouting comment=teamviewer dst-port=5938 \
    new-connection-mark=Browse passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=5938 \
    new-connection-mark=Browse passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Crossfire dst-port=\
    16666,10008,13008,13037,13008,10009,49152,49264,2812 new-connection-mark=\
    gaming passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port="16666,10008,13008,13037,\
    13008,10009,12020-12080,13000-13080,49152,49264,2812" \
    new-connection-mark=gaming passthrough=yes protocol=udp
add action=mark-packet chain=prerouting new-packet-mark=ping_pkts_i \
    passthrough=yes protocol=icmp
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.5.50.0/24
add action=dst-nat chain=dstnat dst-port=53 protocol=tcp src-address-list=\
    myip to-addresses=8.8.8.8 to-ports=53
/ip hotspot ip-binding
add comment="anak rolly" mac-address=AC:FE:05:98:A5:2B type=blocked
add comment=zeny disabled=yes mac-address=C0:2E:25:5B:76:61 type=blocked
add comment=andang disabled=yes mac-address=00:08:22:FA:CD:32 type=blocked

/ppp aaa
set use-radius=yes
/ppp secret
add name=edselalao@baybayfiber password=123456 profile="Plan 20mbps" service=\
    pppoe
/system clock
set time-zone-name=Asia/Manila
/system identity
set name=One-Link
/system ntp client
set enabled=yes primary-ntp=129.6.15.29 secondary-ntp=202.90.132.242
/system scheduler
add interval=1d name=800YZ48 on-event="/ip hotspot user remove [find name=800Y\
    Z48]\r\
    \n/ip hotspot active remove [find user=800YZ48]\r\
    \n/system scheduler remove [find name=800YZ48]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/10/2019 start-time=19:45:45
add interval=10h name=505BGT on-event="/ip hotspot user remove [find name=505B\
    GT]\r\
    \n/ip hotspot active remove [find user=505BGT]\r\
    \n/system scheduler remove [find name=505BGT]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=14:51:12
add interval=2h name=200XF92 on-event="/ip hotspot user remove [find name=200X\
    F92]\r\
    \n/ip hotspot active remove [find user=200XF92]\r\
    \n/system scheduler remove [find name=200XF92]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=16:24:39
add interval=2h name=200KNA1 on-event="/ip hotspot user remove [find name=200K\
    NA1]\r\
    \n/ip hotspot active remove [find user=200KNA1]\r\
    \n/system scheduler remove [find name=200KNA1]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=16:32:38
add interval=5h47m44s name=8006Z62 on-event="/ip hotspot user remove [find nam\
    e=8006Z62]\r\
    \n/ip hotspot active remove [find user=8006Z62]\r\
    \n/system scheduler remove [find name=8006Z62]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=16:43:11
add interval=5h47m44s name=800QRZ3 on-event="/ip hotspot user remove [find nam\
    e=800QRZ3]\r\
    \n/ip hotspot active remove [find user=800QRZ3]\r\
    \n/system scheduler remove [find name=800QRZ3]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=16:43:27
add interval=2h name=200ZZ53 on-event="/ip hotspot user remove [find name=200Z\
    Z53]\r\
    \n/ip hotspot active remove [find user=200ZZ53]\r\
    \n/system scheduler remove [find name=200ZZ53]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=16:48:38
add interval=2h name=200ESR3 on-event="/ip hotspot user remove [find name=200E\
    SR3]\r\
    \n/ip hotspot active remove [find user=200ESR3]\r\
    \n/system scheduler remove [find name=200ESR3]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=16:53:01
add interval=7h name=5009GA1 on-event="/ip hotspot user remove [find name=5009\
    GA1]\r\
    \n/ip hotspot active remove [find user=5009GA1]\r\
    \n/system scheduler remove [find name=5009GA1]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=16:57:59
add interval=4h name=3052YS on-event="/ip hotspot user remove [find name=3052Y\
    S]\r\
    \n/ip hotspot active remove [find user=3052YS]\r\
    \n/system scheduler remove [find name=3052YS]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:02:39
add interval=4h name=30EV64 on-event="/ip hotspot user remove [find name=30EV6\
    4]\r\
    \n/ip hotspot active remove [find user=30EV64]\r\
    \n/system scheduler remove [find name=30EV64]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:02:41
add interval=3h name=300QJD3 on-event="/ip hotspot user remove [find name=300Q\
    JD3]\r\
    \n/ip hotspot active remove [find user=300QJD3]\r\
    \n/system scheduler remove [find name=300QJD3]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:03:42
add interval=7h name=500EXK7 on-event="/ip hotspot user remove [find name=500E\
    XK7]\r\
    \n/ip hotspot active remove [find user=500EXK7]\r\
    \n/system scheduler remove [find name=500EXK7]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:06:59
add interval=1h30m name=160DA72 on-event="/ip hotspot user remove [find name=1\
    60DA72]\r\
    \n/ip hotspot active remove [find user=160DA72]\r\
    \n/system scheduler remove [find name=160DA72]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:12:53
add interval=1h42m name=2003TT3 on-event="/ip hotspot user remove [find name=2\
    003TT3]\r\
    \n/ip hotspot active remove [find user=2003TT3]\r\
    \n/system scheduler remove [find name=2003TT3]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:17:53
add interval=1h name=100GQZ2 on-event="/ip hotspot user remove [find name=100G\
    QZ2]\r\
    \n/ip hotspot active remove [find user=100GQZ2]\r\
    \n/system scheduler remove [find name=100GQZ2]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:20:01
add interval=2h name=200YWR9 on-event="/ip hotspot user remove [find name=200Y\
    WR9]\r\
    \n/ip hotspot active remove [find user=200YWR9]\r\
    \n/system scheduler remove [find name=200YWR9]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:21:19
add interval=1h name=100XXC7 on-event="/ip hotspot user remove [find name=100X\
    XC7]\r\
    \n/ip hotspot active remove [find user=100XXC7]\r\
    \n/system scheduler remove [find name=100XXC7]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:21:45
add interval=1h name=10SFBR on-event="/ip hotspot user remove [find name=10SFB\
    R]\r\
    \n/ip hotspot active remove [find user=10SFBR]\r\
    \n/system scheduler remove [find name=10SFBR]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:22:00
add interval=1h6m name=11064V1 on-event="/ip hotspot user remove [find name=11\
    064V1]\r\
    \n/ip hotspot active remove [find user=11064V1]\r\
    \n/system scheduler remove [find name=11064V1]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:25:31
add interval=1h name=100NA69 on-event="/ip hotspot user remove [find name=100N\
    A69]\r\
    \n/ip hotspot active remove [find user=100NA69]\r\
    \n/system scheduler remove [find name=100NA69]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:27:34
add interval=1h name=100AAB4 on-event="/ip hotspot user remove [find name=100A\
    AB4]\r\
    \n/ip hotspot active remove [find user=100AAB4]\r\
    \n/system scheduler remove [find name=100AAB4]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:37:08
add interval=1h name=100B8G8 on-event="/ip hotspot user remove [find name=100B\
    8G8]\r\
    \n/ip hotspot active remove [find user=100B8G8]\r\
    \n/system scheduler remove [find name=100B8G8]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:40:18
add interval=1h name=1004WE2 on-event="/ip hotspot user remove [find name=1004\
    WE2]\r\
    \n/ip hotspot active remove [find user=1004WE2]\r\
    \n/system scheduler remove [find name=1004WE2]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:40:29
add interval=1h name=100U832 on-event="/ip hotspot user remove [find name=100U\
    832]\r\
    \n/ip hotspot active remove [find user=100U832]\r\
    \n/system scheduler remove [find name=100U832]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:41:57
add interval=1h name=100EAT5 on-event="/ip hotspot user remove [find name=100E\
    AT5]\r\
    \n/ip hotspot active remove [find user=100EAT5]\r\
    \n/system scheduler remove [find name=100EAT5]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:45:10
add interval=1h name=100D9P5 on-event="/ip hotspot user remove [find name=100D\
    9P5]\r\
    \n/ip hotspot active remove [find user=100D9P5]\r\
    \n/system scheduler remove [find name=100D9P5]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:45:21
add interval=1h name=100J368 on-event="/ip hotspot user remove [find name=100J\
    368]\r\
    \n/ip hotspot active remove [find user=100J368]\r\
    \n/system scheduler remove [find name=100J368]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:47:07
add interval=4h name=30U87X on-event="/ip hotspot user remove [find name=30U87\
    X]\r\
    \n/ip hotspot active remove [find user=30U87X]\r\
    \n/system scheduler remove [find name=30U87X]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:48:19
add interval=1h42m name=17097E4 on-event="/ip hotspot user remove [find name=1\
    7097E4]\r\
    \n/ip hotspot active remove [find user=17097E4]\r\
    \n/system scheduler remove [find name=17097E4]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:51:39
add interval=1h name=100T3T6 on-event="/ip hotspot user remove [find name=100T\
    3T6]\r\
    \n/ip hotspot active remove [find user=100T3T6]\r\
    \n/system scheduler remove [find name=100T3T6]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:52:01
add interval=1h name=10026C4 on-event="/ip hotspot user remove [find name=1002\
    6C4]\r\
    \n/ip hotspot active remove [find user=10026C4]\r\
    \n/system scheduler remove [find name=10026C4]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:52:03
add interval=1h name=100HEN3 on-event="/ip hotspot user remove [find name=100H\
    EN3]\r\
    \n/ip hotspot active remove [find user=100HEN3]\r\
    \n/system scheduler remove [find name=100HEN3]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:52:11
add interval=2h name=2007AA5 on-event="/ip hotspot user remove [find name=2007\
    AA5]\r\
    \n/ip hotspot active remove [find user=2007AA5]\r\
    \n/system scheduler remove [find name=2007AA5]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:54:16
add interval=1h30m name=150A273 on-event="/ip hotspot user remove [find name=1\
    50A273]\r\
    \n/ip hotspot active remove [find user=150A273]\r\
    \n/system scheduler remove [find name=150A273]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:56:49
add interval=2h name=2008JJ6 on-event="/ip hotspot user remove [find name=2008\
    JJ6]\r\
    \n/ip hotspot active remove [find user=2008JJ6]\r\
    \n/system scheduler remove [find name=2008JJ6]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=17:57:04
add interval=1h name=1002GB1 on-event="/ip hotspot user remove [find name=1002\
    GB1]\r\
    \n/ip hotspot active remove [find user=1002GB1]\r\
    \n/system scheduler remove [find name=1002GB1]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:06:03
add interval=1h name=100BKD9 on-event="/ip hotspot user remove [find name=100B\
    KD9]\r\
    \n/ip hotspot active remove [find user=100BKD9]\r\
    \n/system scheduler remove [find name=100BKD9]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:08:08
add interval=1h name=10JTCV on-event="/ip hotspot user remove [find name=10JTC\
    V]\r\
    \n/ip hotspot active remove [find user=10JTCV]\r\
    \n/system scheduler remove [find name=10JTCV]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:09:34
add interval=2h name=2006QB9 on-event="/ip hotspot user remove [find name=2006\
    QB9]\r\
    \n/ip hotspot active remove [find user=2006QB9]\r\
    \n/system scheduler remove [find name=2006QB9]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:10:16
add interval=4h name=30R8TF on-event="/ip hotspot user remove [find name=30R8T\
    F]\r\
    \n/ip hotspot active remove [find user=30R8TF]\r\
    \n/system scheduler remove [find name=30R8TF]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:10:30
add interval=1h name=100A276 on-event="/ip hotspot user remove [find name=100A\
    276]\r\
    \n/ip hotspot active remove [find user=100A276]\r\
    \n/system scheduler remove [find name=100A276]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:10:36
add interval=1h name=1008HA9 on-event="/ip hotspot user remove [find name=1008\
    HA9]\r\
    \n/ip hotspot active remove [find user=1008HA9]\r\
    \n/system scheduler remove [find name=1008HA9]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:13:51
add interval=3h name=3009C73 on-event="/ip hotspot user remove [find name=3009\
    C73]\r\
    \n/ip hotspot active remove [find user=3009C73]\r\
    \n/system scheduler remove [find name=3009C73]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:15:41
add interval=1h name=100EG61 on-event="/ip hotspot user remove [find name=100E\
    G61]\r\
    \n/ip hotspot active remove [find user=100EG61]\r\
    \n/system scheduler remove [find name=100EG61]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/11/2019 start-time=18:16:38
