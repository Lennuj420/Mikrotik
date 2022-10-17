########## Coinnectify on-logout script ###########
#inport
:local sendTelegram [:parse [/system script get sendTelegram source] ]
#variables
:local message "";
:local limitUptime 00:00:00;
:local uptime 00:00:00;
:local remainingTime 00:00:00;
:if ($cause != "session timeout") do={
  :set limitUptime [/ip hotspot user get $user limit-uptime];
  :set uptime [/ip hotspot user get $user uptime];
  :set remainingTime ($limitUptime - $uptime);
  :set $message "$user time paused: $remainingTime";
} else={
  :set $message "$user time's up";
}
[$sendTelegram HotspotMonitoring $message];
########## Coinnectify on-logout script ###########