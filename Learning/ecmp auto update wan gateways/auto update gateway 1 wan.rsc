#get new gateway from intreface by finding comment "isp1"
:local newGateway [ip dhcp-client get [find comment="isp1"] gateway];
#get current gateway from route by finding a comment "isp1"
:local currentGateway [/ip route get [find comment="isp1"] gateway ];
#compare new gateway and current gateway
:if ($newGateway != $currentGateway) do={
#if true: update current gateway
    /ip route set [find comment="isp1"] gateway=$newGateway;
}