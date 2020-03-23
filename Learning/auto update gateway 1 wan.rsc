#get new gateway from intreface by finding comment "isp1"
:local newGateway [ip dhcp-client get [find comment="isp1"] gateway];
#get current gateway from route by finding a comment "isp1"
:local currentGateway [/ip route get [find comment"isp1"] gateway ];
#compare new gateway and current gateway
:if ($newGateway != $currentGateway) do={
#if true: update current gateway
    /ip route set [find comment="isp1"] gateway=$newGateway;
}
/system script add name="ecmp-update-wan1-gateway" source={
    :if ([/system scheduler get "ecmp-update-wan1-gateway" run-count]<=1) do={ 
        /system script run "ecmp-initial-wan1-gateway";
     }
     :local temp;
     :local wan1NewGateway;
     :set temp $wan1CurrentGateway
     :set wan1NewGateway[\
         /ip address get \
         [/ip address find comment="wan1"] \
         address \
     ]
     :if ($temp != $wan1NewGateway) do={
         /ip route set [find comment="isp1"] gateway=$wan1NewGateway;
     }
}
/system script add name="ecmp-initial-wan1-gateway" source={
    :global wan1CurrentGateway;
    :global wan1CurrentGateway [/ip route get [find comment=wan1] gateway];
}
/system scheduler add name="ecmp-check-wan1-gateway" interval=1m on-event="ecmp-update-wan1-gateway"
