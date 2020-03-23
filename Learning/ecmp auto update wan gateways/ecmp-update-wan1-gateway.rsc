/system script add name="ecmp-update-wan1-gateway" source={
    :if ([/system scheduler get "ecmp-update-wan1-gateway" run-count]<=1) do={ 
        /system script run "ecmp-initial-wan1-gateway";
     }
     :local temp;
     :local wan1NewGateway;
     :set temp $wan1CurrentGateway
     :set wan1NewGateway [/ip address get [/ip address find comment="wan1"] address];
     :if ($temp != $wan1NewGateway) do={
         /ip route set [find comment="isp1"] gateway=$wan1NewGateway;
     }
}