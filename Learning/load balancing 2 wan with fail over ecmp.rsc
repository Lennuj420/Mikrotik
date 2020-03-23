#this config is doesnt use pcc by greentechrevolution in youtube

#pre requisite:
#both wanshould be already configured
#no default route

#1. add new route for the WANs
/ip route
add dst-address=0.0.0.0/0 gateway=*wan1*,*wan2* check-gateway=ping disable=no

#2. add nat masquerade

#3.mark packets
/ip firewall mangle
add chain=input in-interface=ether1_wan1 action=mark-connection new-connection-mark=wan1 passtrough=yes
add chain=input in-interface=ether2_wan2 action=mark-connection new-connection-mark=wan2 passtrough=yes
add chain=output connection-mark=wan1 action=mark-routing new-routing-mark=to_wan1 passtrough=yes
add chain=output connection-mark=wan2 action=mark-routing new-routing-mark=to_wan2 passtrough=yes

#4. add marked routes
/ip route
add dst-address=0.0.0.0/0 gateway=*wan 1 gateway* check-gateway=ping routing-mark=to_wan1 
add dst-address=0.0.0.0/0 gateway=*wan 2 gateway* check-gateway=ping routing-mark=to_wan2 