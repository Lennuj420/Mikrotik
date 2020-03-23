#Script: auto update route gateway ecmp wan1
#Description:
#this script update wan1,wan2 and ecmp route gateway. 
#this script should be run from DHCP advance tab or put it on the scripts and run via external script
#this script should be triggered when new dhcp-client lease is bound/assigned.
#---------
#Version: 1
#Author: junnel verceluz

#get current wan1-route gateway
:local wan1CurrentGateway [/ip route get [find comment="wan1"] gateway];
#get current wan2-route gateway
:local wan2CurrentGateway [/ip route get [find comment="wan2"] gateway];
#get new wan1 gateway from dhcp
:local wan1NewGateway [/ip dhcp-client get [find comment="wan1"] gateway];
#get new wan2 gateway from dhcp
:local wan2NewGateway [/ip dhcp-client get [find comment="wan2"] gateway];
#update wan1 gateway
/ip route set [find comment="wan1"] gateway=$"gateway-address"; 
#update wan2 gateway
/ip route set [find comment="wan1"] gateway=$"gateway-address";

#update ecmp gateway--------------------------------------------
/ip route set [find comment="ecmp"] gateway= $wan1NewGateway,$wan2NewGateway;


