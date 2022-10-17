########## Coinnectify on-login script ##########
# :delay 5s;
:log info "importing sendTelegram script"; #debug
:local sendTelegram [:parse [/system script get sendTelegram source]]
:log info "importing sendTelegram script"; #debug

#variables
:local loginBy [/ip hotspot active get [find user=$user] login-by];
:local price [/ip hotspot active get [find user=$user] comment];

:if ($loginBy = "admin") do={ 
  :log info "updating sales"; #debug
  :local currenttodayincome [/system script get [find name=todayincome] source];
  :local newtodayincome ($price + $currenttodayincome);
  /system script set todayincome source="$newtodayincome";
  :local currentmonthlyincome [/system script get [find name=monthlyincome] source];
  :local newmonthlyincome ($price + $currentmonthlyincome);
  /system script set monthlyincome source="$newmonthlyincome";

  # if ([:len [/system scheduler find name="$user"]] = 0) do={ 
  # :log info "creating validity scheduler"; #debug
  # :local validity;
  # if ($price < 30) do={ :set $validity "1d00:00:00";} else={ :set $validity "3d00:00:00";}
  # /system scheduler add name="$user" disable=no interval=$validity on-event=":if ([:len [/ip hotspot active find user=$user]]>0) do={ /ip hotspot active remove [find user=$user];}\r\n:if ([:len [/ip hotspot cookie find user=$user]]>0) do={ /ip hotspot cookie remove [find user=$user];}\r\n:if ([:len [/ip hotspot user find user=$user]]>0) do={ /ip hotspot user remove [find name=$user];}\r\n:if ([:len [/system scheduler find name=$user]]>0) do={ /system scheduler remove [find name=$user];}\r\n";
  # } else={ 
  # :log info "updating validity scheduler"; #debug
  # :local validity ([/system scheduler get [find name="058631"] interval]+[/ip hotspot user get [find name=$user] limit-uptime]);
  # /system scheduler set [find name=$user] interval=$validity;
  # }

  :delay 5s;
  :log info "removing comment"; #debug
  /ip hotspot user set [find name=$user] comment="";

  :log info "sending telegram"; #debug
  :local message "$user P$price.00 %0A%0AToday Income: $newtodayincome %0AMonthly Income: $newmonthlyincome";
  [$sendTelegram SalesMonitoring $message]
} else={ 
  :log info "sending telegram"; #debug
  :local message "$user time resumed";
  [$sendTelegram HotspotMonitoring $message]
}

########## Coinnectify on-login script ##########



#todo
#create a scheduler every hour to check all user limit uptime - uptime if = 0 remove the user