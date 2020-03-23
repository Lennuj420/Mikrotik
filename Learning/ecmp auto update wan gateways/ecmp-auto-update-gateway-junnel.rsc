/system script add name="ecmp-update-wan-gateway" source={
    #get wan1
     :local wan1CurrentGateway [/ip route get [find comment="wan1"] gateway];
     :local wan1NewGateway [/ip dhcp-client get [find comment="wan1"] gateway];
    #update wan1
     :if ($wan1CurrentGateway != $wan1NewGateway) do={
         /ip route set [find comment="wan1"] gateway=$wan1NewGateway;
     }

     #get wan2
     :local wan2CurrentGateway [/ip route get [find comment="wan2"] gateway];
     :local wan2NewGateway [/ip dhcp-client get [find comment="wan2"] gateway];
     #update wan2
     :if ($wan2CurrentGateway != $wan2NewGateway) do={
         /ip route set [find comment="wan2"] gateway=$wan2NewGateway;
     }

     /ip route set [find comment="ecmp"] gateway=($wan1NewGateway,$wan2NewGateway);
}

/system scheduler add name="ecmp-check-gateway" interval=1m on-event="ecmp-update-wan1-gateway";
#############################
#create a different trigger
#############################