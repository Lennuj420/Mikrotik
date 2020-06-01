#todo

#declare input read function
#how to use: 
:global read do={:return};


#ask user what is the name of the device
:put "what is the name of the device?";
/system identity set name=[$read];

#setup ISP
    #use ether 1 as ISP
    #add comment
    /interface set ether1 comment="wan1"
    #set DHCP client, no NTP, no DNS
    /ip dhcp-client add comment="wan1-dhcp" interface=wan1 use-peer-dns=no use-peer-ntp=no add-default-route=no disabled=no
    #set route gateway
    /ip route add comment=wan-route gateway=[/ip dhcp-client get [find comment~"wan1"] gateway] check-gateway=ping disabled=no;
    #set manual dns
    /ip dns set servers=1.0.0.1,8.8.4.4 allow-remote-requests=yes;
    #set nat masquerade
    /ip firewall nat add comment="wan1-nat" chain=srcnat out-interface=wan1 action=masquerade disabled=no

#set dynamic lan
    #rename ethernet
    /interface set ether3 comment="lan1";
    #create ip pool
    /ip pool add comment=lan1-ip-pool ranges=10.10.1.10-10.10.1.254;
    #create network
    /ip dhcp-server network add comment=lan1-dhcp-network address=10.10.1.0/24  gateway=10.10.1.1
    #create dhcp server
    /ip dhcp-server add name="lan1-dhcp-server" comment="lan1-dhcp-server" 

#set user
    #admin
    :put "create new password for admin"
    /user set admin password=[$read]
    #remote-admin
    /user add name="remote-admin" password="damin21345" group="full"