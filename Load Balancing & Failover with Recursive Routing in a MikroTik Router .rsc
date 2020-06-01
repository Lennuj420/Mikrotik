part 2 - https://www.youtube.com/watch?v=fDD1wkLfFRQ&t=27s
part 3 - https://www.youtube.com/watch?v=-KsZtOdmPWk

#tips for communicating cloud hosted router on vmware
    #set vmware network adapter 0 to bridge lan
    #set vmware network adapter 0 to bridge wlan
    
    #set eth0 - lan
    #set eth1 - wlan
    


#router1--------------------------

#set dhcp ether 1
#set nat ether1
#create bridge 1 & 2
#add ether1 to bridge1
#add ether2 to bridge2
#create ip pool
    #ppoe1
        #addresses 10.0.100.2-10.0.100.50
    #ppoe2
        #addresses 10.0.200.2-10.0.200.-50
#add ppoe1-profile
    #add local addres: 10.0.100.1
    #remote address: ppoe1 ip pool
    #limits
    #rate-limits: 5M/5M
#add ppoe2 profile
    #local address: 10.0.200.1
    #remote addresses: ppoe2 ip pool
    #rate limits: 5M/5M
#create ppoe1 server
    #interface:brdige1
    #profile: ppoe1 profile
#create ppoe2 server
    #interface bridge2
    #profile: ppoe2 profile
#create ppp secret
    #name: user1
    #password: user1
    #service: ppoe
    #profile: ppoe1
    -
    #name: user2
    #password: user2
    #service: ppoe
    #profile: ppoe2
    -
    #name: user3
    #password: user3
    #service: ppoe
    #profile: ppoe1
    -
    #name: user4
    #password: user4
    #service: ppoe
    #profile: ppoe2
#router1 ------------------------------

#router2 ---------------------------
#ppp
    #add interface - ppoe client
        #name: ppoe-out1
        #select interface: ether1
        #dial-oute tab
            #user: user1
            #password: user1
            #*add default route
            #*use peer dns
    #add interface: ppoe-client
        #name: ppoe-out2
        #interface: ether2
        #dial-out tab
            #user: user2
            #password: user2
            #*add default route
            #*use peer dns


    
    
    


