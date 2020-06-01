#**
#* @author     Junnel 
#* @datetime   28 March 2020
#* @perpose    create bandwidth based load balancing
#* @input      get which interface to set as isps
#* @output     set the router to bandwidth based load balance between two isp
#*/

#add comments to name the ports

#setup internet to wan ports

#set route gateway (using ip from dhcp-client)
/ip route add comment="wan1" gateway=[/ip dhcp-client get [find comment~"wan1"] gateway] check-gateway=ping distance=1 disabled=no;
/ip route add comment="wan2" gateway=[/ip dhcp-client get [find comment~"wan2"] gateway] check-gateway=ping distance=2 disabled=no;

# {:local ip [:pick [/ip address get [:find comment~"wan1"] address] 0 [find [/ip address get [:find comment~"wan1"] address ] "/"]]; /ip route add comment="wan1" gateway=$ip  check-gateway=ping distance=1 disabled=no;}




/ip route add comment="wan1-bandwidth-based-load-balancing-route" gateway=[/ip dhcp-client get [find comment~"wan1"] gateway] check-gateway=ping  routing-mark="to-wan1-route" distance=1 disabled=no;
/ip route add comment="wan2-bandwidth-based-load-balancing-route" gateway=[/ip dhcp-client get [find comment~"wan2"] gateway] check-gateway=ping  routing-mark="to-wan2-route" distance=1 disabled=no;

#add address list
/ip firewall address-list add comment=wan1 address=[/ip route get [find gateway=ether1] dst-address] list=connected
/ip firewall address-list add comment=wan2 address=[/ip route get [find gateway=ether2] dst-address] list=connected
/ip firewall address-list add comment=lan1 address=[/ip dhcp-server network get [find comment="lan1-network"] address] list=connected
/ip firewall address-list add comment=lan1 address=[/ip dhcp-server network get [find comment="lan1-network"] address] list=lan
/ip firewall address-list add comment=wlan1 address=[/ip dhcp-server network get [find comment="wlan1-network"] address] list=connected
/ip firewall address-list add comment=wlan1 address=[/ip dhcp-server network get [find comment="wlan1-network"] address] list=lan

#add mangle to allow connected to be accepted(will not be proccessed anymore)
/ip firewall mangle add comment="accept all packets from connected networks" chain=prerouting src-address-list=connected dst-address-list=connected action=accept;

#mark incoming connection so we can reply trough the same wan interface
#received from wan1
/ip firewall mangle add comment="wan1->ros" chain=input connection-mark=no-mark in-interface="ether1" action=mark-connection new-connection-mark="wan1->ros";
#received from wan2
/ip firewall mangle add comment="wan2->ros" chain=input connection-mark=no-mark in-interface="ether2" action=mark-connection new-connection-mark="wan2->ros";

#reply through the same wan port using route-mark
#reply to wan1
/ip firewall mangle add comment="ros->wan1" chain=output connection-mark="wan1->ros" action=mark-routing new-routing-mark="to-wan1-route";
#reply to wan2
/ip firewall mangle add comment="ros->wan2" chain=output connection-mark="wan2->ros" action=mark-routing new-routing-mark="to-wan2-route";

#manage LANs
#when a connection is initiated from isp1 to lan, we should also reply to isp1
/ip firewall mangle add comment="wan1->lan" chain=forward connection-mark=no-mark in-interface="ether1" action=mark-connection new-connection-mark="wan1->lan";
/ip firewall mangle add comment="wan2->lan" chain=forward connection-mark=no-mark in-interface="ether2" action=mark-connection new-connection-mark="wan2->lan";
/ip firewall mangle add comment="lan->wan1" chain=prerouting connection-mark="wan1->lan" src-address-list="lan" action=mark-routing new-routing-mark="to-wan1-route";
/ip firewall mangle add comment="lan->wan2" chain=prerouting connection-mark="wan2->lan" src-address-list="lan" action=mark-routing new-routing-mark="to-wan2-route";


#lan to wan
/ip firewall mangle add chain=prerouting connection-mark=no-mark src-address-list="lan" dst-address-list=!connected dst-address-type=!local action=mark-connection new-connection-mark="lan->wan";
/ip firewall mangle add chain=prerouting connection-mark="lan->wan" src-address-list="lan" action=mark-routing new-routing-mark="to-wan1-route" comment="load-balancing-here";

#sticky connections
/ip firewall mangle add comment="sticky-connection" chain=prerouting connection-mark="lan->wan" routing-mark="to-wan1-route" action=mark-connection new-connection-mark="sticky-wan1-connection";
/ip firewall mangle add chain=prerouting connection-mark="lan->wan" routing-mark="to-wan2-route" action=mark-connection new-connection-mark="sticky-wan2-connection";
/ip firewall mangle add chain=prerouting connection-mark="sticky-wan1-connection" src-address-list="lan" action=mark-routing new-routing-mark="to-wan1-route";
/ip firewall mangle add chain=prerouting connection-mark="sticky-wan2-connection" src-address-list="lan" action=mark-routing new-routing-mark="to-wan2-route";


#load balancing script, to be added to traffic monitor, to be triggered when bandwidth is GREATER THAN the allocated bandwidth
/tool traffic-monitor add name="bandwidth-based-LB-switch-to-wan2" interface=[/interface get [find comment=wan1 ] name] traffic=received trigger=above threshold=5M on-event=":log warning \"LB Debug: wan1 overloaded, switching connections to wan2\";\r\n/ip firewall mangle set [find comment=\"load-balancing-here\"] new-routing-mark=\"to-wan2-route\";"
#load balancing script, to be added to traffic monitor, to be triggered when bandwidth is GREATER THAN the allocated bandwidth
/tool traffic-monitor add name="bandwidth-based-LB-switch-to-wan2" interface=[/interface get [find comment=wan1 ] name] traffic=received trigger=below threshold=5M on-event=":log warning \"LB Debug: wan1 normalized, switching connections to wan1\";\r\n/ip firewall mangle set [find comment=\"load-balancing-here\"] new-routing-mark=\"to-wan1-route\";"



#questions to be answered,
#how to seperate bandwidth wareness from download to upload, what if the upload is the one only reaching the limit?
#how to transfer upload connections to isp2

#can 

#get current wan1-route gateway
:global wan1CurrentGateway [/ip route get [find comment="wan1"] gateway];
:log info $wan1CurrentGateway;
#get current wan2-route gateway
:global wan2CurrentGateway [/ip route get [find comment="wan2"] gateway];
:log info $wan2CurrentGateway;
#get new wan1 gateway from dhcp
:global wan1NewGateway [/ip dhcp-client get [find interface=ether1] gateway];
:log info $wan1NewGateway;
#get new wan2 gateway from dhcp
:global wan2NewGateway [/ip dhcp-client get [find interface=ether2] gateway];
:log info $wan2NewGateway;
#update wan1 gateway
/ip route set [find comment="wan1"] gateway=$wan1NewGateway ;
#update wan2 gateway
/ip route set [find comment="wan2"] gateway=$wan2NewGateway;





#bandwidth based load balancing idea v1
#catch all traffic from lan and mark the connections
#differentiate traffic if WAN>LAN(download) or LAN->WAN(upload)
#make the wan to reply through the same connection/ mark connection and route
#make sticky connections
#trigger a log for each rule with limit according to speed of isp
#parse log to trigger a an event to change route of new connection either upload or download