#Script: auto update route gateway ecmp wan1
#Description:
#this script update wan1 and ecmp route gateway. 
#this script should be run from DHCP advance tab or put it on the scripts and run via external script
#this script should be triggered when new dhcp-client lease is bound/assigned.
#---------
#Version: 1
#Author: junnel verceluz

#get current wan1-route gateway
:local wan1CurrentGateway [/ip route get [find comment="wan1"] gateway];
#get current wan1-route gateway
:local wan2CurrentGateway [/ip route get [find comment="wan2"] gateway];
#get new wan1 gateway from dhcp
:local wan1NewGateway [/ip dhcp-client get [find comment="wan1"] gateway];

#update wan1 route gateway
/ip route set [find comment="wan1"] gateway=$"gateway-address"; 
#update ecmp gateway--------------------------------------------
    :if([:typeof $wan1ECMPGatewayIndex] != nil) \
    do={ 
    #update the route gatway array w/ index
    :set ($ECMPGateways ->$wan1ECMPGatewayIndex) $wan1CurrentGateway;
    } \
    else={
        #if $wan1ECMPGatewayIndex = nil : add new the ip to the array
        :set ($ECMPGateways->[:len $ECMPGateways]) $wan1NewGateway;
    };
    /ip route set [find comment="ecmp"] gateway= $ECMPGateways;
#update ecmp gateway--------------------------------------------


#note next problem how to remove the un used gateway


