/system script add name="ecmp-update-wan1-gateway" source={
    :if ([/system scheduler get "ecmp-update-wan1-gateway" run-count]<=1) do={ 
        /system script run "ecmp-initial-wan1-gateway";
     }
     :local temp $wan1CurrentGateway;
     :local wan1NewGateway [/ip dhcp-client get [find comment="wan1"] gateway];
     :if ($temp != $wan1NewGateway) do={
         /ip route set [find comment="wan1"] gateway=$wan1NewGateway;
     }
}

/system script add name="ecmp-initial-wan1-gateway" source={
    :global wan1CurrentGateway [/ip route get [find comment=wan1] gateway];
}

/system scheduler add name="ecmp-check-wan1-gateway" interval=1m on-event="ecmp-update-wan1-gateway";