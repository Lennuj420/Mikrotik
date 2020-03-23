# feb/08/2020 18:01:23 by RouterOS 6.42.12
# software id = LR2A-BSEK
#
# model = RB941-2nD
# serial number = A1420AC6CE29
/interface bridge
add admin-mac=64:D1:54:18:F6:07 auto-mac=no comment=defconf fast-forward=no \
    name=bridge
add disabled=yes name=hotspot
/interface wireless
set [ find default-name=wlan1 ] disabled=no mode=ap-bridge name=wlan2 ssid=\
    "zer08ight shop" wireless-protocol=802.11
/interface ethernet
set [ find default-name=ether1 ] mac-address=64:D1:54:18:F6:06
set [ find default-name=ether2 ] mac-address=64:D1:54:18:F6:07 name=\
    ether2-master
set [ find default-name=ether3 ] mac-address=64:D1:54:18:F6:08
set [ find default-name=ether4 ] mac-address=64:D1:54:18:F6:09
/interface list
add exclude=dynamic name=discover
add name=mactel
add name=mac-winbox
add name=WAN
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa-psk,wpa2-psk eap-methods="" \
    mode=dynamic-keys supplicant-identity=MikroTik wpa-pre-shared-key=\
    zer08ight wpa2-pre-shared-key=zer08ight
add authentication-types=wpa-psk,wpa2-psk eap-methods="" mode=dynamic-keys \
    name=profile supplicant-identity=MikroTik wpa-pre-shared-key=zer08ight \
    wpa2-pre-shared-key=zer08ight
add eap-methods="" group-ciphers="" management-protection=allowed name=\
    hotspot supplicant-identity="" unicast-ciphers=""
/ip firewall layer7-protocol
add name=stream regexp="^.+(youtube.com|dailymotion|metacafe|mccont|googlevide\
    o|akamaihd.net).*\$"
add name=streaming regexp="^.+(videoplayback|video).*\$"
add name=document regexp="^.*get.+\\.(pdf|doc|docx|xlsx|xls|rtf|ppt|ppt).*\$"
add name="high download" regexp="^.*get.+\\.(exe|rar|iso|zip|7zip|0[0-9][1-9]|\
    flv|mkv|avi|mp4|3gp|rmvb|mp3|img|dat|mov).*\$\r\
    \n"
add name="Limit IDM" regexp=\
    "get /.*(user-agent: Mozilla / 4.0 | range: bytes =)"
/ip hotspot profile
add dns-name=Lucifer.hotspot.com hotspot-address=192.168.3.1 html-directory=\
    InternalBootstrapHotspotV3 name=hsprof1
/ip pool
add name=dhcp ranges=192.168.2.10-192.168.2.254
add name=hs-pool-11 ranges=192.168.3.2-192.168.3.254
/ip dhcp-server
add address-pool=dhcp authoritative=after-2sec-delay disabled=no interface=\
    bridge name=defconf
add address-pool=hs-pool-11 disabled=no interface=hotspot lease-time=1h name=\
    dhcp1
/ip hotspot
add address-pool=hs-pool-11 disabled=no idle-timeout=none interface=hotspot \
    name=server1 profile=hsprof1
/queue tree
add disabled=yes name=Hotspot packet-mark=browser-packet parent=hotspot
add disabled=yes name="1. Mobile Games" packet-mark=gaming-packet parent=\
    Hotspot
add disabled=yes limit-at=300k max-limit=1M name="2.Mobile Browsing" \
    packet-mark=browser-packet parent=Hotspot
add disabled=yes limit-at=300k max-limit=1M name="3. Mobile Streaming" \
    packet-mark=streaming-packet parent=Hotspot
add name="all download" parent=bridge queue=default
add name="all upload" parent=ether1 queue=default
add name="1. Online Games" packet-mark=gaming-packet parent="all download" \
    priority=1 queue=default
add name="1. online games ul" packet-mark=gaming-packet parent="all upload" \
    priority=1 queue=default
add limit-at=300k max-limit=8M name="2. browser" packet-mark=browser-packet \
    parent="all download" priority=2 queue=default
add limit-at=300k max-limit=1M name="2. browser ul" packet-mark=\
    browser-packet parent="all upload" priority=2 queue=default
add limit-at=300k max-limit=4M name="3. streaming" packet-mark=\
    streaming-packet parent="all download" priority=3 queue=default
add limit-at=100k max-limit=100k name="3. steaming ul" packet-mark=\
    streaming-packet parent="all upload" priority=3 queue=default
/snmp community
set [ find default=yes ] addresses=0.0.0.0/0
/interface bridge filter
# no interface
add action=drop chain=forward in-interface=*7
# no interface
add action=drop chain=forward out-interface=*7
/interface bridge port
add bridge=bridge comment=defconf interface=ether2-master
add bridge=bridge comment=defconf interface=*5
add bridge=bridge interface=*7
add bridge=bridge interface=*8
add bridge=bridge interface=*9
add bridge=bridge interface=ether3
add bridge=bridge interface=ether4
add bridge=hotspot interface=*B
add bridge=bridge interface=wlan2
/ip neighbor discovery-settings
set discover-interface-list=discover
/interface list member
add interface=ether2-master list=discover
add interface=ether3 list=discover
add interface=ether4 list=discover
add list=discover
add interface=bridge list=discover
add list=discover
add list=discover
add interface=hotspot list=discover
add interface=ether2-master list=mactel
add list=mactel
add interface=ether2-master list=mac-winbox
add list=mactel
add list=mac-winbox
add list=mac-winbox
add interface=ether1 list=WAN
add interface=bridge list=mactel
/interface wireless access-list
add ap-tx-limit=1000000
/ip address
add address=192.168.2.1/24 comment=defconf interface=ether2-master network=\
    192.168.2.0
add address=192.168.3.1/24 comment="hotspot network" interface=ether2-master \
    network=192.168.3.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid disabled=no interface=\
    ether1
/ip dhcp-server network
add address=192.168.2.0/24 comment=defconf dns-server=8.8.8.8 domain=8.8.4.4 \
    gateway=192.168.2.1
add address=192.168.3.0/24 comment="hotspot network" gateway=192.168.3.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip dns static
add address=192.168.2.1 name=router
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=drop chain=forward connection-limit=1,32 disabled=yes \
    layer7-protocol="!Limit IDM" protocol=tcp
/ip firewall mangle
add action=mark-connection chain=prerouting comment=streaming \
    connection-state=new connection-type="" layer7-protocol=stream \
    new-connection-mark=streaming-conn passthrough=yes
add action=mark-connection chain=prerouting layer7-protocol=streaming \
    new-connection-mark=streaming-conn passthrough=yes
add action=mark-packet chain=prerouting connection-mark=streaming-conn \
    new-packet-mark=streaming-packet passthrough=no
add action=mark-connection chain=prerouting comment=download \
    connection-state=new layer7-protocol=document new-connection-mark=\
    download-conn passthrough=yes
add action=mark-connection chain=prerouting layer7-protocol="high download" \
    new-connection-mark=download-conn passthrough=yes
add action=mark-packet chain=prerouting connection-mark=download-conn \
    new-packet-mark=download-packet passthrough=no
add action=mark-connection chain=prerouting comment=browser dst-port=\
    80,443,8080 new-connection-mark=browser-conn passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=80,443,8080 \
    new-connection-mark=browser-conn passthrough=yes protocol=udp
add action=mark-packet chain=prerouting connection-mark=browser-conn \
    new-packet-mark=browser-packet passthrough=no
add action=mark-connection chain=prerouting comment=\
    "===========================GAME TRAFFIC==========================" \
    dst-port=9110 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting comment=Crossfire dst-port=\
    13006-13008 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=16666 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=28012 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=10008-10009 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=12000-12080,13000-13080 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Steam dst-port=\
    27036,60181 new-connection-mark=gaming-connection passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=27015-28999 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="DOTA 2" dst-port=27005 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp src-port=27015-28999
add action=mark-connection chain=prerouting dst-port=4380 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Team Fortress 2" \
    dst-port=50010 new-connection-mark=gaming-connection passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting comment="Gunz 2 The Second Duel" \
    dst-port=20100,20200 new-connection-mark=gaming-connection passthrough=\
    yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=50157-50165 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=38073 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Loadout dst-port=\
    5353,57101 new-connection-mark=gaming-connection passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=5222 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=Garena dst-port=\
    2099,9100,9200,30000 new-connection-mark=gaming-connection passthrough=\
    yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=9110 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=999,7456-7459,8687-8688 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=21900,1513-1522,18080 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp src-port=1513-1522
add action=mark-connection chain=forward new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp src-port=1513
add action=mark-connection chain=forward dst-port=1513 new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    4000-4200,53299,54397,59642 new-connection-mark=gaming-connection \
    passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=49579,53261,41000 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Blackshot dst-port=19000 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment="Heroes of Newerth" \
    dst-port=11235-11335 new-connection-mark=gaming-connection passthrough=\
    yes protocol=udp
add action=mark-connection chain=prerouting dst-port=8005,11033 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=7456,8005,11033,9100 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Elsword dst-port=\
    9301,9300 new-connection-mark=gaming-connection passthrough=yes protocol=\
    tcp
add action=mark-connection chain=prerouting dst-port=8299 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="League of Legends (LoL)" \
    dst-port=5000-5500 new-connection-mark=gaming-connection passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=8393-8400 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=2099,5223,5222 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=20466,21033,20466,8088 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=20466,21033,20466,8088 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Strife dst-port=\
    50515-50530 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=58263-58264 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=59329-59331 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=7031 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=11235 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="World of Tanks" \
    dst-port=64294,32811 new-connection-mark=gaming-connection passthrough=\
    yes protocol=udp
add action=mark-connection chain=prerouting dst-port=49912-49913 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=10501-10502 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=25274 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="DC Universe Online" \
    dst-port=11028 new-connection-mark=gaming-connection passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=11010 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Kingdom Under Fire 2" \
    dst-port=10000,13000 new-connection-mark=gaming-connection passthrough=\
    yes protocol=tcp
add action=mark-connection chain=prerouting comment="Aeria Ignite" dst-port=\
    51808 new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=51809 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Aura Kingdom" dst-port=\
    5567,5569 new-connection-mark=gaming-connection passthrough=yes protocol=\
    tcp
add action=mark-connection chain=prerouting dst-port=10013-10023 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment="Soldier Front 2" \
    dst-port=50207,7533 new-connection-mark=gaming-connection passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=30000-30007 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=27932,27935 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=59961-59963 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Scarlet Blade" dst-port=\
    55891 new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=10001 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment="Starcraft II" dst-port=\
    57736 new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Warcraft III" dst-port=\
    6000-6152 new-connection-mark=gaming-connection passthrough=yes protocol=\
    tcp
add action=mark-connection chain=prerouting dst-port=6000-6152 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=1900 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=1900 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Idate dst-port=8132,8133 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=Mercenary dst-port=3000 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment="Assualt Fire" dst-port=\
    28526,9030,8000,65000,28540 new-connection-mark=gaming-connection \
    passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    28526,9030,8000,65000,28540 new-connection-mark=gaming-connection \
    passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    7552,7515,7631,7586,7620,7570 new-connection-mark=gaming-connection \
    passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=9101,8008,8733,9989 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=49900-49999 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Point Blank" dst-port=\
    39190 new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=29890,40003-40007 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Dragon Nest" dst-port=\
    14300-14500 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=27501-27502 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=53265,62774,56277 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Ranked Gaming Client" \
    dst-port=6153-6600 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=18600 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=50081 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Ragnarok dst-port=61286 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=5000 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=BalikRO dst-port=5121 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment="Cabal Ph" dst-port=\
    38111-38125 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=3544 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=6800-6899 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp src-port=6800-6899
add action=mark-connection chain=prerouting comment=Audition dst-port=\
    18806,18811-18815 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting comment="Ran Online" dst-port=\
    5001,5502,5105,5003,5205,5305 new-connection-mark=gaming-connection \
    passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=BabyRAN dst-port=5028 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=BossRAN dst-port=5103 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=Grandchase dst-port=\
    9300,9400,9700 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=9401,9600,9610 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Perfect World" dst-port=\
    29000 new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment=Shaiya dst-port=\
    50226-50229 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting comment=KOS dst-port=6300 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=6300 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Flyff dst-port=\
    28000,15400 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting comment=Warrock dst-port=5330 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=5330 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Brawl Busters" dst-port=\
    25001 new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=25001 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="High Street 5" dst-port=\
    4000 new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=61435,64303 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Yulgang 2" dst-port=\
    15002-15030 new-connection-mark=gaming-connection passthrough=yes \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=62967,63471 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp src-port=50983
add action=mark-connection chain=prerouting comment=Rakion dst-port=64542 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment="Freestyle Gunz" \
    dst-port=7709-7791 new-connection-mark=gaming-connection passthrough=yes \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=6000 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=51004,15796 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Eligium dst-port=\
    3724,8086 new-connection-mark=gaming-connection passthrough=yes protocol=\
    tcp
add action=mark-connection chain=prerouting dst-port=3724,8086 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting comment=Others dst-port=\
    38117,38124,38154,6383,6292 new-connection-mark=gaming-connection \
    passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    12463,13055,5103,8227,8126,48722,3478 new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=41000,18081,18091,10902 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    41000,65000,10007,10003,8890,8000 new-connection-mark=gaming-connection \
    passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting dst-port=10006,6230,11051,11061 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting comment="Dota 2" dst-address=\
    125.5.6.1 new-connection-mark=gaming-connection passthrough=yes
add action=mark-connection chain=prerouting comment="Yulgang 2" dst-address=\
    113.23.148.71 new-connection-mark=gaming-connection passthrough=yes
add action=mark-connection chain=prerouting dst-address=203.117.135.38 \
    new-connection-mark=gaming-connection passthrough=yes
add action=mark-connection chain=prerouting comment=BalikRO dst-address=\
    23.228.70.168 new-connection-mark=gaming-connection passthrough=yes
add action=mark-connection chain=prerouting comment="High Street 5" \
    dst-address=203.116.228.202 new-connection-mark=gaming-connection \
    passthrough=yes
add action=mark-connection chain=prerouting dst-address=203.116.228.157 \
    new-connection-mark=gaming-connection passthrough=yes
add action=mark-connection chain=prerouting comment="Soldier Front 2" \
    dst-address=108.163.135.0/24 new-connection-mark=gaming-connection \
    passthrough=yes
add action=mark-connection chain=prerouting comment="Rank Gaming Client" \
    dst-address=119.81.66.124 new-connection-mark=gaming-connection \
    passthrough=yes
add action=mark-connection chain=prerouting comment="Point Blank" \
    dst-address=123.242.206.0/24 new-connection-mark=gaming-connection \
    passthrough=yes
add action=mark-connection chain=prerouting comment="Dragon Nest" \
    dst-address=203.116.155.0/24 new-connection-mark=gaming-connection \
    passthrough=yes
add action=mark-connection chain=prerouting comment="Assault Fire" \
    dst-address=202.57.118.0/24 new-connection-mark=gaming-connection \
    passthrough=yes
add action=mark-connection chain=prerouting comment="DOTA2 Singapore Server" \
    dst-address=103.28.54.1 new-connection-mark=gaming-connection \
    passthrough=yes
add action=mark-connection chain=prerouting dst-address=103.10.124.1 \
    new-connection-mark=gaming-connection passthrough=yes
add action=mark-packet chain=prerouting connection-mark=gaming-connection \
    new-packet-mark=gaming-packet passthrough=no
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    out-interface=ether1 out-interface-list=WAN
/ip hotspot user
add comment="M-Tik Voucher" limit-uptime=1h name=GGWP9095 password=GGWP9095 \
    server=server1
/system clock
set time-zone-name=Asia/Manila
/tool mac-server
set allowed-interface-list=mactel
/tool mac-server mac-winbox
set allowed-interface-list=mac-winbox
