:local newGateway [ip dhcp-client get [find comment="isp1"] gateway];
:local currentGateway [/ip route get [find comment="isp1"] gateway ];
:if ($newGateway != $currentGateway) do={
    /ip route set [find comment="isp1"] gateway=$newGateway;
}