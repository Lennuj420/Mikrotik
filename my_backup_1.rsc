# feb/05/2020 21:23:50 by RouterOS 6.45.8
# software id = EXEI-2QTY
#
# model = RBD52G-5HacD2HnD
# serial number = B4A10B9E8CEA
/interface bridge
add admin-mac=C4:AD:34:7A:EC:04 auto-mac=no comment=defconf name=bridge
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
/ip pool
add name=dhcp ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge name=defconf
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge comment=defconf interface=ether5
add bridge=bridge comment=defconf interface=wlan1
add bridge=bridge comment=defconf interface=wlan2
add bridge=bridge interface=vwlan1_hotspot
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
/ip address
add address=192.168.88.1/24 comment=defconf interface=ether2 network=\
    192.168.88.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid disabled=no interface=\
    ether1
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 comment=defconf name=router.lan
/ip firewall filter
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
    connection-state=established,related
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
/system clock
set time-zone-name=Asia/Manila
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
