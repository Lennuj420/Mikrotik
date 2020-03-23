:local newgw1 [/ip address get [find interface="pppoe-out1"] network];
:local routegw1 [/ip route get [find comment="isp1"] gateway ];
:if ($newgw1 != $routegw1) do={
     /ip route set [find comment="isp1"] gateway=$newgw1;
}
:local newgw2 [/ip address get [find interface="pppoe-out2"] network];
:local routegw2 [/ip route get [find comment="isp2"] gateway ];
:if ($newgw2 != $routegw2) do={
     /ip route set [find comment="isp2"] gateway=$newgw2;
}