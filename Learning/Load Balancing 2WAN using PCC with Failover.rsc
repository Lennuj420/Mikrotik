create target netwrok address, input interface is: LAN bridge & WLAN bridge
/ip firewall mangle
add chain=prerouting dst-address=*wan1 network* in-interface=*lan bridge name* action=accept;
add chain=prerouting dst-address=*wan2 network* in-interface=*lan bridge name* action=accept;
add chain=prerouting dst-address=*wan2 network* in-interface=*wlan bridge name* action=accept;
add chain=prerouting dst-address=*wan2 network* in-interface=*wlan bridge name* action=accept;

mark connections that are made trough the interfaces
/ip firewall mangle
add chain=prerouting in-interface=wan1 connection-mark=no-mark action=mark-connection new-connection-mark=wan1_conn passtrough=yes;
add chain=prerouting in-interface=wan2 connection-mark=no-mark action=mark-connection new-connection-mark=wan2_conn passtrough=yes;

configure Per Connection classifier (PCC) - this will tell where the traffic is going
/ip firewall mangle
add chain=prerouting in-interface=*LAN bridge* connection-mark=no-mark per-connection-classifier=bothaddress:2/0 dst-address-type=!local action=mark-connection new-mark-connection=wan1;
add chain=prerouting in-interface=*LAN bridge* connection-mark=no-mark per-connection-classifier=bothaddress:2/1 dst-address-type=!local action=mark-connection new-mark-connection=wan2;
add chain=prerouting in-interface=*WLAN bridge* connection-mark=no-mark per-connection-classifier=bothaddress:2/0 dst-address-type=!local action=mark-connection new-mark-connection=wan1;
add chain=prerouting in-interface=*WLAN bridge* connection-mark=no-mark per-connection-classifier=bothaddress:2/1 dst-address-type=!local action=mark-connection new-mark-connection=wan2;

create a mark on the route of the traffic has taken from the interface
/ip firewall mangle
add chain=prerouting connection-mark=wan1 in-interface=*lan bridge* action=mark-routing new-routing-mark="to_wan1" passtrough=yes;
add chain=prerouting connection-mark=wan2 in-interface=*lan bridge* action=mark-routing new-routing-mark="to_wan2" passtrough=yes;
add chain=prerouting connection-mark=wan1 in-interface=*wlan bridge* action=mark-routing new-routing-mark="to_wan1" passtrough=yes;
add chain=prerouting connection-mark=wan2 in-interface=*wlan bridge* action=mark-routing new-routing-mark="to_wan2" passtrough=yes;

create connection mark to output chain for traffic leaving the router
/ip firewall mangle
add chain=output connection-mark=wan1 action=mark-routing new-routing-mark=to_wan1 passtrough=yes 
add chain=output connection-mark=wan2 action=mark-routing new-routing-mark=to_wan2 passtrough=yes

create firewall nat masquerade to wan1 and wan2
/ip firewall nat
add chain=srcnat out-interface=ether1_wan1 action=masquerade
add chain=srcnat out-interface=ether2_wan2 action=masquerade

create routes for wan1 and wan2
/ip routes
add dst-address=0.0.0.0/0 gateway=*wan1 gateway ip* check-gateway=ping distance=1 routing-mark=to_wan1;
add dst-address=0.0.0.0/0 gateway=*wan2 gateway ip* check-gateway=ping distance=1 routing-mark=to_wan2;
add dst-address=0.0.0.0/0 gateway=*wan1 gateway ip* check-gateway=ping distance=1;
add dst-address=0.0.0.0/0 gateway=*wan2 gateway ip* check-gateway=ping distance=1;



end note:
create a way to dynamically change the dst-address of WAN network interfaces if the WAN IP changed
-you can try to compare wan route gateway every specified interval
-you can ping the wan gateway if failed, get new ip and change the static values respectedly
