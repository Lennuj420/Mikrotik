# nov/12/2019 20:33:16 by RouterOS 6.45.6
# software id = TMG8-YD03
#
# model = RB750Gr3
# serial number = 8B000A4884B6
/interface bridge
add name=LocalNet
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot login-by=http-chap
/interface bridge port
add bridge=LocalNet interface=ether4
add bridge=LocalNet interface=ether5
/interface detect-internet
set detect-interface-list=all
/ip address
add address=192.168.253.2/24 interface=ether1 network=192.168.253.0
add address=192.168.254.2/24 interface=ether2 network=192.168.254.0
add address=10.10.10.1/24 interface=LocalNet network=10.10.10.0
add address=192.168.252.2/24 interface=ether3 network=192.168.252.0
/ip cloud
set ddns-enabled=yes

#firewall mangle
/ip firewall mangle
add action=mark-connection chain=input in-interface=ether1 \
    new-connection-mark=ISP1 passthrough=yes
add action=mark-connection chain=input in-interface=ether2 \
    new-connection-mark=ISP2 passthrough=yes
add action=mark-routing chain=output connection-mark=ISP1 new-routing-mark=\
    ISP1 passthrough=yes
add action=mark-routing chain=output connection-mark=ISP2 new-routing-mark=\
    ISP2 passthrough=yes
add action=mark-connection chain=input in-interface=ether3 \
    new-connection-mark=ISP3 passthrough=yes
add action=mark-routing chain=output connection-mark=ISP3 new-routing-mark=\
    ISP3 passthrough=yes
/ip firewall nat
add action=masquerade chain=srcnat src-address=10.10.10.0/24
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat out-interface=ether2
add action=masquerade chain=srcnat out-interface=ether3
/ip route
add distance=1 gateway=192.168.253.254 routing-mark=ISP1
add distance=1 gateway=192.168.254.254 routing-mark=ISP2
add distance=1 gateway=192.168.252.254 routing-mark=ISP3
add check-gateway=ping distance=1 gateway=192.168.254.254,192.168.253.254
/ip service
set telnet disabled=yes
set ftp disabled=yes
set api disabled=yes
set api-ssl disabled=yes
#interrupted
