foreach i in [/ip hotspot user find profile="juanfi"] do={
  :local uptime [/ip hotspot user get $i uptime];
  :local limit [/ip hotspot user get $i limit-uptime];
  :if (($limit-$uptime) = 00:00:00) do={ 
    /ip hotspot user remove $i;
  }
}