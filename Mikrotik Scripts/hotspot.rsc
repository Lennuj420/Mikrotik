  
/interface bridge
add name=bridge-hotspot
add name=bridge1
 
/interface list
add name=WAN
add name=LAN
 
/ip firewall layer7-protocol
add comment=video name=streaming regexp=videoplayback|video

/ip hotspot profile

set [ find default=yes ] html-directory="" login-by=cookie,http-chap,http-pap \
    name=hotspot use-radius=yes
add dns-name=wifi.ni.eboy hotspot-address=10.0.0.1 html-directory=hotspot6 \
    login-by=cookie,http-chap,http-pap,trial name=hsprof1 trial-uptime-limit=\
    50s use-radius=yes

/ip hotspot user profile
set [ find default=yes ] idle-timeout=5m insert-queue-before=first name=vip \
    on-login="{\r\
    \n:if ( [ /ip hotspot user get \$user comment ] != \"\" ) do={\r\
    \n:local datex [/ip hotspot user get \$user comment ]\r\
    \n:local pecah [:toarray [:pick \$datex ([:find \$datex \":\"]+1) [:len \$\
    datex]]]\r\
    \n:local tgl [:pick \$pecah 1]\r\
    \n:if ([:len \$tgl] != 0) do={\r\
    \n:local komen [:pick \$datex 0 [:find \$datex \":\"]]\r\
    \n:local harga [:pick \$pecah 0]\r\
    \n:local date [ /system clock get date ]\r\
    \n:local days \$tgl\r\
    \n:local mdays  {31;28;31;30;31;30;31;31;30;31;30;31}\r\
    \n:local months {\"jan\"=1;\"feb\"=2;\"mar\"=3;\"apr\"=4;\"may\"=5;\"jun\"\
    =6;\"jul\"=7;\"aug\"=8;\"sep\"=9;\"oct\"=10;\"nov\"=11;\"dec\"=12}\r\
    \n:local monthr  {\"jan\";\"feb\";\"mar\";\"apr\";\"may\";\"jun\";\"jul\";\
    \"aug\";\"sep\";\"oct\";\"nov\";\"dec\"}\r\
    \n:local dd  [:tonum [:pick \$date 4 6]]\r\
    \n:local yy [:tonum [:pick \$date 7 11]]\r\
    \n:local month [:pick \$date 0 3]\r\
    \n:local mm (:\$months->\$month)\r\
    \n:set dd (\$dd+\$days)\r\
    \n:local dm [:pick \$mdays (\$mm-1)]\r\
    \n:if (\$mm=2 && ((\$yy&3=0 && (\$yy/100*100 != \$yy)) || \$yy/400*400=\$y\
    y) ) do={ :set dm 29 }\r\
    \n:while (\$dd>\$dm) do={\r\
    \n:set dd (\$dd-\$dm)\r\
    \n:set mm (\$mm+1)\r\
    \n:if (\$mm>12) do={\r\
    \n:set mm 1\r\
    \n:set yy (\$yy+1)\r\
    \n}\r\
    \n:set dm [:pick \$mdays (\$mm-1)]\r\
    \n:if (\$mm=2 &&  ((\$yy&3=0 && (\$yy/100*100 != \$yy)) || \$yy/400*400=\$\
    yy) ) do={ :set dm 29 }\r\
    \n};\r\
    \n:local res \"\$[:pick \$monthr (\$mm-1)]/\"\r\
    \n:if (\$dd<10) do={ :set res (\$res.\"0\") }\r\
    \n:set \$res \"\$res\$dd/\$yy\"\r\
    \n:local waktu [/system clock get time]\r\
    \n[ /ip hotspot user set \$user comment=\"\$komen: \\\"\$harga\\\" \$res -\
    \_\$waktu\" ]\r\
    \n}\r\
    \n}\r\
    \n}"

/ip pool
add name=dhcp ranges=192.168.10.10-192.168.18.254
add name=hs-pool-8 ranges=10.0.0.2-10.0.0.254

/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge1 name=dhcp1
add address-pool=hs-pool-8 disabled=no interface=bridge-hotspot lease-time=1h \
    name=dhcp2

/ip hotspot
add address-pool=hs-pool-8 addresses-per-mac=1 disabled=no interface=\
    bridge-hotspot name=hotspot1 profile=hsprof1

#queue list
/queue simple
add disabled=yes max-limit=3M/3M name=Streaming packet-marks=streaming-packet queue=\
    pcq-upload-default/pcq-download-default target=10.0.0.0/24 total-queue=\
    default
add disabled=yes max-limit=3M/3M name=Browsing packet-marks=browsing-packet priority=5/5 \
    queue=pcq-upload-default/pcq-download-default target=10.0.0.0/24 \
    total-queue=default
add disabled=yes max-limit=3M/5M name=Others packet-marks=others-packet priority=5/5 \
    queue=pcq-upload-default/pcq-download-default target=10.0.0.0/24 \
    total-queue=default
add disabled=yes max-limit=3M/5M name=Games packet-marks=gaming-packet priority=1/1 queue=\
    pcq-upload-default/pcq-download-default target=10.0.0.0/24 total-queue=\
    default



/interface bridge port
add bridge=bridge1 interface=ether2
add bridge=bridge-hotspot interface=wlan1
add bridge=bridge-hotspot interface=ether3
add bridge=bridge-hotspot interface=ether4
add bridge=bridge-hotspot interface=ether5

/interface detect-internet
set detect-interface-list=all
/interface list member
add interface=ether1 list=WAN
add disabled=yes interface=wlan1 list=LAN
add interface=bridge1 list=LAN
add disabled=yes interface=wlan1 list=LAN
/ip address
add address=192.168.10.2/24 interface=ether2 network=192.168.10.0
add address=10.0.0.1/24 comment="hotspot network" interface=bridge-hotspot \
    network=10.0.0.0
/ip dhcp-client
add dhcp-options=hostname,clientid disabled=no interface=ether1
/ip dhcp-server network
add address=10.0.0.0/24 comment="hotspot network" gateway=10.0.0.1
add address=192.168.10.0/24 gateway=192.168.10.2 netmask=24
/ip dns
set servers=8.8.8.8,8.8.4.4
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes


#firewall mangle
/ip firewall mangle
add disabled=yes action=mark-connection chain=prerouting comment=Games dst-port=\
    30097-30147,30021-30022,30100-30110,5001,5003,9001 new-connection-mark=\
    gaming-connection passthrough=yes protocol=tcp
add disabled=yes action=mark-connection chain=prerouting dst-port=\
    30097-30147,30021-30022,30100-30110,5001,5003,9001 new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp
add disabled=yes action=mark-connection chain=prerouting dst-port=\
    30000-30999,34242,41741,49354 new-connection-mark=gaming-connection \
    passthrough=yes protocol=tcp
add disabled=yes action=mark-connection chain=prerouting dst-port=5000-5599,30000-30999 \
    new-connection-mark=gaming-connection passthrough=yes protocol=tcp
add disabled=yes action=mark-connection chain=prerouting dst-port=\
    5000-5099,5228-5299,5353-5399,5501-5599,30102-30199 new-connection-mark=\
    gaming-connection passthrough=yes protocol=tcp
add disabled=yes action=mark-connection chain=prerouting new-connection-mark=\
    gaming-connection passthrough=yes protocol=udp src-port=27015-28999
add disabled=yes action=mark-connection chain=prerouting dst-port=4380 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add disabled=yes action=mark-connection chain=prerouting dst-port=9992,30000-30999,57538 \
    new-connection-mark=gaming-connection passthrough=yes protocol=udp
add disabled=yes action=mark-packet chain=prerouting connection-mark=gaming-connection \
    new-packet-mark=gaming-packet passthrough=no
add disabled=yes action=mark-routing chain=prerouting connection-mark=gaming-connection \
    new-routing-mark=management passthrough=no
add disabled=yes action=mark-connection chain=prerouting comment=streaming dst-port=443 \
    layer7-protocol=streaming new-connection-mark=streaming-connection \
    passthrough=yes protocol=tcp
add disabled=yes action=mark-connection chain=prerouting layer7-protocol=streaming \
    new-connection-mark=streaming-connection passthrough=yes
add disabled=yes action=mark-connection chain=prerouting dst-port=1935,2545-2565 \
    layer7-protocol=streaming new-connection-mark=streaming-connection \
    passthrough=yes protocol=tcp
add disabled=yes action=mark-packet chain=prerouting connection-mark=streaming-connection \
    layer7-protocol=streaming new-packet-mark=streaming-packet passthrough=\
    yes
add disabled=yes action=mark-routing chain=prerouting layer7-protocol=streaming \
    new-routing-mark=management passthrough=no
add action=mark-connection chain=prerouting comment=Browsing dst-port=\
    20,21,53,80,443,8000,8080,18080,18090 new-connection-mark=\
    browsing-connection passthrough=yes protocol=tcp
add disabled=yes action=mark-connection chain=prerouting dst-port=\
    20,21,53,80,443,8000,8080,18080,18090 new-connection-mark=\
    browsing-connection passthrough=yes protocol=udp
add disabled=yes action=mark-packet chain=prerouting connection-mark=browsing-connection \
    new-packet-mark=browsing-packet passthrough=no
add action=mark-routing chain=prerouting connection-mark=browsing-connection \
    new-routing-mark=management passthrough=no
add disabled=yes action=mark-connection chain=prerouting comment=Others dst-port=\
    35000-65535 new-connection-mark=others-connection passthrough=yes \
    protocol=tcp
add disabled=yes action=mark-connection chain=prerouting dst-port=35000-65535 \
    new-connection-mark=others-connection passthrough=yes protocol=udp
add disabled=yes action=mark-packet chain=prerouting connection-mark=others-connection \
    new-packet-mark=others-packet passthrough=no
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface-list=WAN
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.0.0.0/24


/radius
add address=127.0.0.1 secret=123 service=hotspot
/radius incoming
set accept=yes
/system clock
set time-zone-name=Asia/Manila
 

