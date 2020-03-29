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

##############add traffic shaping

#handle video streaming
/ip firewall layer7-protocol add name="streaming" regexp=video|videoplayback;

/queue tree
#download
add disabled=yes limit-at=256k max-limit=25M name="main_download" parent=global queue=pcq-download-default;
add disabled=yes limit-at=56k max-limit=20M name=streaming_dl packet-mark=streaming parent=main_download queue=pcq-download-default;
add disabled=yes limit-at=56k max-limit=10M name=heavy_dl packet-mark=heavy_traffic
parent=main_download queue=pcq-download-default;
add disabled=yes limit-at=128k max-limit=15M name=light_dl packet-mark=light_traffic
parent=main_download priority=1 queue=pcq-download-default;
#upload
add disabled=yes limit-at=256k max-limit=15M name=main_upload parent=global queue=pcq-upload-default
add disabled=yes limit-at=56k max-limit=5M name=streaming parent=main_upload queue=pcq-upload-default
add disabled=yes limit-at=56k max-limit=5M name=heavy_up packet-mark=heavy_traffic parent=main_upload queue=pcq-upload-default
add disabled=yes limit-at=128 max-limit=10M name=light_upload packet-mark=light_traffic parent=main_upload priority=1 queue=pcq-upload-default

#mangle rules
/ip firewall mangle
add chain=prerouting layer7-protocol=streaming action=mark-connection new-connection-mark=streaming_conn passthrough=yes comment="streaming";
add chain=prerouting connection-mark=streaming_conn action=mark-packet new-packet-mark=streaming_packet passthrough=no;
add chain=prerouting connection-mark=streaming action=mark-routing new-routing-mark=main;
#all_traffi
add chain=prerouting action=mark-connection new-connection-mark=all_traffic passthrough=yes comment="all_traffic";
#light
add chain=prerouting connection-bytes=1-100000 connection-mark=all_traffic action=mark-connection  new-connection-mark=light_traffic_conn passthrough=yes comment="light_traffic_conn";

#heavy
add chain=prerouting connection-mark=!light_traffic action=mark-connection new-connection-mark=heavy_traffic_conn passthrough=yes comment="heavy_traffic-conn";

#light
add chain=prerouting connection-mark=light_traffic_conn new-packet-mark=light_traffic_packet passthrough=yes comment="light_traffic_packet";
add chain=prerouting connection-mark=light_traffic action=mark-routing new-routing-mark=main passthrough=no;
#heavy
add chain=prerouting connection-mark=heavy_traffic_conn new-packet-mark=heavy_traffic_packet passthrough=yes comment="heavy_traffic_packet";
add chain=prerouting connection-mark=heavy_traffic action=mark-routing new-routing-mark=main passthrough=no;
