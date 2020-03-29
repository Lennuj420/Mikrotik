#this config is doesnt use pcc by greentechrevolution in youtube

#pre requisite:
#both wanshould be already configured
#no default route

#enable-dhcp client
/ip dhcp-client add interface=[/interface get [find default-name="ether1"] name] use-peer-dns=no use-peer-ntp=no add-default-route=no disabled=no comment="wan1-dhcp-client";
/ip dhcp-client add interface=[/interface get [find default-name="ether2"] name] use-peer-dns=no use-peer-ntp=no add-default-route=no disabled=no comment="wan2-dhcp-client";

#add dns
/ip dns set servers=1.1.1.1,8.8.8.8;

#add new route for ecmp
/ip route add dst-address=0.0.0.0/0 gateway=[/ip dhcp-client get [find comment="wan1-dhcp-client"] gateway],[/ip dhcp-client get [find comment="wan2-dhcp-client"] gateway] check-gateway=ping disabled=no;

#add nat masquerade
#isp1/ether1
/ip firewall nat add chain=srcnat out-interface=[/interface  get [find default-name="ether1" ] name] action=masquerade comment="wan1-nat-masquerade";
#isp2/ether2
/ip firewall nat add chain=srcnat out-interface=[/interface  get [find default-name="ether2" ] name] action=masquerade comment="wan2-nat-masquerade";

#mark packets
/ip firewall mangle
add chain=input in-interface=ether1_wan1 action=mark-connection new-connection-mark="wan1-connection" passtrough=yes comment="ECMP connection mark";
add chain=input in-interface=ether2_wan2 action=mark-connection new-connection-mark="wan2-connection" passtrough=yes;
add chain=output connection-mark="wan1-connection" action=mark-routing new-routing-mark= "to-wan1-route" passtrough=yes comment="ECMP route mark";
add chain=output connection-mark="wan2-connection" action=mark-routing new-routing-mark="to-wan2-route" passtrough=yes;

#add marked routes
/ip route add dst-address=0.0.0.0/0 gateway=[/ip dhcp-client get [find comment="wan1-dhcp-client"] gateway] check-gateway=ping routing-mark="to-wan1-route" comment="to wan1";
/ip route add dst-address=0.0.0.0/0 gateway=[/ip dhcp-client get [find comment="wan2 -dhcp-client"] gateway] check-gateway=ping routing-mark="to-wan2-route" comment="to wan2";