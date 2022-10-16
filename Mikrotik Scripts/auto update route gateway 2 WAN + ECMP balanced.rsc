#Script: auto update route gateway ecmp wan1
#Description:
#this script update wan1,wan2 and ecmp route gateway. 
#put it on the scripts and run 
#this script should be triggered when new dhcp-client lease is bound/assigned.
#---------
#Version: 2
#DATE: 04-02-2020
#Author: junnel verceluz


#add triggers in dhcp-cleint----------------------------------------
#check wan1-dhcp
:if ([:len [find comment=wan1]]>0) do={
    #set-wan1-dhcp
    /ip dhcp-client set [find comment=wan1] script="if (bound=1) do={/system script run \"ecmp-auto-update-wan-route-gateway\";}";
} else={
    #add-wan1-dhcp
    /ip dhcp-client add comment="wan1" interface=[/interface ethernet get [find default-name=ether1] name] use-peer-dns=no use-peer-ntp=no disabled=no add-default-route=no script="if (bound=1) do={/system script run\"ecmp-auto-update-route-gateway\"}";  
};
#check wan2-dhcp
:if ([:len [find comment=wan2]]>0) do={
    #set wan2-dhcp
    /ip dhcp-client set [find comment=wan2] script="if (bound=1) do={/system script run \"ecmp-auto-update-wan-route-gateway\";}";
} else={
    #add wan2-dhcp
    /ip dhcp-client add comment="wan2" interface=[/interface ethernet get [find default-name=ether2] name] use-peer-dns=no use-peer-ntp=no disabled=no add-default-route=no script="if (bound=1) do={/system script run \"ecmp-auto-update-route-gateway\"}";
};
#add triggers in dhcp-cleint----------------------------------------


#get wan1
:local wan1CurrentGateway [/ip route get [find comment="wan1"] gateway];
:local wan1NewGateway [/ip dhcp-client get [find comment="wan1"] gateway];

#check wan1 gateway if changed
:if ($wan1CurrentGateway != $wan1NewGateway) do={ 
#update wan1 gateway
/ip route set [find comment="wan1"] gateway=$wan1NewGateway;
}
#get wan2
:local wan2CurrentGateway [/ip route get [find comment="wan2"] gateway];
:local wan2NewGateway [/ip dhcp-client get [find comment="wan2"] gateway];
#check wan2 gateway if changed
:if ($wan2CurrentGateway != $wan2NewGateway) do={
#update wan1 gateway
/ip route set [find comment="wan2"] gateway=$wan2NewGateway;
}


if ([:len [/ip route find comment ~"ecmp"]]>0 ) do={
#update-ecmp
/ip route set [find comment="ecmp"] gateway=($wan1NewGateway,$wan2NewGateway);
}
else={
#add ecmp
}
