# mar/02/2020 23:56:06 by RouterOS 6.45.8
# software id = EXEI-2QTY
#
# model = RBD52G-5HacD2HnD
# serial number = B4A10B9E8CEA
/interface bridge
add name="bridge-WLAN 2Ghz"
/interface ethernet
set [ find default-name=ether1 ] name=ether1_WAN1
set [ find default-name=ether2 ] name=ether2_WAN2
set [ find default-name=ether3 ] name=ether3_LAN1
set [ find default-name=ether4 ] name=ether4_LAN2
set [ find default-name=ether5 ] name=ether5_WiredAccess
/interface wireless
set [ find default-name=wlan2 ] comment="WLAN 5Ghz" ssid=MikroTik
/interface wireless manual-tx-power-table
set wlan2 comment="WLAN 5Ghz"
/interface wireless nstreme
set wlan2 comment="WLAN 5Ghz"
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa2-psk eap-methods="" management-protection=\
    allowed mode=dynamic-keys name=wifiwifi supplicant-identity="" \
    wpa2-pre-shared-key=wifiwifi
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n comment="WLAN 2Ghz" country=\
    philippines disabled=no mode=ap-bridge name="wlan1-WLAN 2Ghz" \
    security-profile=wifiwifi ssid="hAP ac2" wps-mode=disabled
/interface wireless manual-tx-power-table
set "wlan1-WLAN 2Ghz" comment="WLAN 2Ghz"
/interface wireless nstreme
set "wlan1-WLAN 2Ghz" comment="WLAN 2Ghz"
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name="pool-WLAN 2Ghz" ranges=192.168.1.254-192.168.2.10
/ip dhcp-server
add address-pool="pool-WLAN 2Ghz" disabled=no interface="bridge-WLAN 2Ghz" \
    name="dchp-WLAn 2Ghz"
/interface bridge port
add bridge="bridge-WLAN 2Ghz" interface="wlan1-WLAN 2Ghz"
/ip address
add address=172.168.1.1/24 interface=ether5_WiredAccess network=172.168.1.0
add address=192.168.2.1/24 comment="WLAN 2Ghz" interface="bridge-WLAN 2Ghz" \
    network=192.168.2.0
/ip dhcp-client
add disabled=no interface=ether1_WAN1
/ip dhcp-server network
add address=192.168.2.0/24 comment="WLAN 2Ghz" gateway=192.168.2.1
/ip firewall nat
add action=masquerade chain=srcnat
/system clock
set time-zone-name=Asia/Manila
/system identity
set name="hAP ac2"
