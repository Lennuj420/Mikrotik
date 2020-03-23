/system script add name="ecmp-initial-wan1-gateway" source={
    :global wan1CurrentGateway;
    :global wan1CurrentGateway [/ip route get [find comment=wan1] gateway];
}