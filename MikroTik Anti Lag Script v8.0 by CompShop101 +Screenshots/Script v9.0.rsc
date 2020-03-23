/ip dhcp-server
add disabled=no insert-queue-before=bottom interface=bridge lease-script=":loc\
    al queueName \"Guest - \$leaseActMAC\";\r\
    \n:if ((\$leaseBound=1) && (\$leaseActIP>\"192.168.88.100\")) do {\r\
    \n    /queue simple add name=\$queueName target=(\$leaseActIP . \"/32\") p\
    arent=00_LAN max-limit=2M/2M bucket-size=0/0 comment=[/ip dhcp-server leas\
    e get [find where active-mac-address=\$leaseActMAC && active-address=\$lea\
    seActIP] host-name];\r\
    \n}\r\
    \n:if ((\$leaseBound=0) && (\$leaseActIP>\"192.168.88.100\")) do {\r\
    \n    /queue simple remove \$queueName\r\
    \n}" name=dhcp
/ip pool
add name=default-dhcp ranges=192.168.88.101-192.168.88.110
/queue simple
add bucket-size=0/0 max-limit=5M/20M name=00_LAN target=192.168.88.0/24
add bucket-size=0/0 max-limit=5M/20M name=hs-<hotspot> target=200.2.20.0/24
add bucket-size=0/0 max-limit=5M/20M name="PC00 Admin" parent=00_LAN target=\
    192.168.88.10/32
add bucket-size=0/0 max-limit=2M/3M name=PC01 parent=00_LAN target=\
    192.168.88.11/32
add bucket-size=0/0 max-limit=2M/3M name=PC02 parent=00_LAN target=\
    192.168.88.12/32
add bucket-size=0/0 max-limit=2M/3M name=PC03 parent=00_LAN target=\
    192.168.88.13/32
add bucket-size=0/0 max-limit=2M/3M name=PC04 parent=00_LAN target=\
    192.168.88.14/32
add bucket-size=0/0 max-limit=2M/5M name=Asus parent=00_LAN target=\
    192.168.88.15/32
add bucket-size=0/0 max-limit=2M/5M name="Oppo F7" parent=00_LAN target=\
    192.168.88.16/32
add bucket-size=0/0 max-limit=2M/5M name="Vivo V7+" parent=00_LAN target=\
    192.168.88.17/32
add bucket-size=0/0 max-limit=2M/5M name=J7 parent=00_LAN target=\
    192.168.88.18/32
add bucket-size=0/0 max-limit=2M/5M name="J7(2)" parent=00_LAN target=\
    192.168.88.19/32
add bucket-size=0/0 max-limit=2M/3M name=HisenseTV parent=00_LAN target=\
    192.168.88.20/32
add bucket-size=0/0 max-limit=2M/5M name=Laptop1 parent=00_LAN target=\
    192.168.88.21/32
add bucket-size=0/0 max-limit=2M/5M name=Laptop2 parent=00_LAN target=\
    192.168.88.22/32
add bucket-size=0/0 max-limit=2M/5M name=Laptop3 parent=00_LAN target=\
    192.168.88.25/32
add bucket-size=0/0 max-limit=2M/1M name=Oppo parent=00_LAN target=\
    192.168.88.98/32
add bucket-size=0/0 max-limit=2M/1M name=MyHomePC parent=00_LAN target=\
    192.168.88.99/32
add bucket-size=0/0 max-limit=2M/1M name=J3 parent=00_LAN target=\
    192.168.88.97/32
/queue type
add kind=pcq name=PCQ-YT pcq-classifier=dst-address pcq-dst-address6-mask=64 \
    pcq-limit=64KiB pcq-rate=2M pcq-src-address6-mask=64
add kind=pcq name=PCQ-0 pcq-classifier=dst-address pcq-limit=64KiB
add kind=pcq name=PCQ-0-up pcq-classifier=src-address pcq-limit=64KiB
set 12 bfifo-limit=64000 kind=bfifo
/queue interface
set wlan1 queue=only-hardware-queue
/queue tree
add bucket-size=0 max-limit=20M name="Total Bandwidth" parent=global queue=\
    default-small
add bucket-size=0 max-limit=5M name="4. Youtube" packet-mark=udp443 parent=\
    "Total Bandwidth" queue=PCQ-YT
add bucket-size=0 max-limit=10M name="2. Browsing, Downloads" packet-mark=\
    tcp80,443 parent="Total Bandwidth" queue=PCQ-0
add bucket-size=0 limit-at=512k max-limit=10M name="1. Games, etc" \
    packet-mark=udp-other parent="Total Bandwidth" priority=1 queue=PCQ-0
add bucket-size=0 max-limit=10M name="3. Torrents (other TCP)" packet-mark=\
    tcp-other parent="Total Bandwidth" queue=PCQ-0
/ip settings
set allow-fast-path=no
/ip firewall mangle
add action=mark-connection chain=prerouting comment=tcp80,443 \
    new-connection-mark=tcp80,443 passthrough=yes port=80,443 protocol=tcp
add action=mark-packet chain=prerouting comment=tcp80,443 connection-mark=\
    tcp80,443 new-packet-mark=tcp80,443 passthrough=no
add action=mark-connection chain=prerouting comment=tcp-other \
    new-connection-mark=tcp-other passthrough=yes protocol=tcp
add action=mark-packet chain=prerouting comment=tcp-other connection-mark=\
    tcp-other new-packet-mark=tcp-other passthrough=no
add action=mark-connection chain=prerouting comment=udp443 \
    new-connection-mark=udp443 passthrough=yes port=443 protocol=udp
add action=mark-packet chain=prerouting comment=udp443 connection-mark=udp443 \
    new-packet-mark=udp443 passthrough=no
add action=mark-connection chain=prerouting comment=udp-other \
    new-connection-mark=udp-other passthrough=yes protocol=udp
add action=mark-packet chain=prerouting comment=udp-other connection-mark=\
    udp-other new-packet-mark=udp-other passthrough=no

