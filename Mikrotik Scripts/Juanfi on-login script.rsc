:local enableTelegram "true"; #enable telegram notification, change from "false"to "true" if you want to enable telegram
:local botToken "5330265867:AAGupphOLCuzd0ijR7WzLMjHTm31dfsI00w"; #telegram bot token
:local chatID "-558110559"; #telegram chatID
:local hotspotFolder "flash/juanfi"; ### hotspot folder for HEX put flash/hotspot for haplite put hotspot only


# :log info "get comment"; #debug 
:local comment [/ip hotspot user get $user comment];

# :log info "get mac address no colon"; #debug 
:local macNoCol;
:for i from=0 to=([:len $"mac-address"] - 1) do={ 
  :local char [:pick $"mac-address" $i]
  :if ($char = ":") do={ 
  :set $char ""
  }
  :set macNoCol ($macNoCol . $char)
  }
# :log info "get mac address no colon success"; #debug 

# :log info "check comment if not empty"; #debug 
:if ([:len $comment]>0) do={ 
  # :log info "get info from comment"; #debug 
  :local infoArray [:toarray [:pick $comment 0 [:len $comment]]];
  # :log info "checking info"; #debug
  :local validity [:pick $infoArray 0];
  :local amt [:pick $infoArray 1];
  :local ext [:pick $infoArray 2];
  :local vendo [:pick $infoArray 3];
  :local totaltime [/ip hotspot user get [find name=$user] limit-uptime];
  :local activeUsers [/ip hotspot active print count-only];
  :local validUntil;
  :local date [ /system clock get date];

  #create schedule
  # :log info "creating scheduler"; #debug 
  :if ([/system scheduler print count-only where name=$user]=0) do={ 
    /system scheduler add name="$user" disable=no start-date=$date interval=$validity on-event=":if ([:len [/ip hotspot active find user=$user]]>0) do={ /ip hotspot active remove [find user=$user];}\r\n:if ([:len [/ip hotspot cookie find user=$user]]>0) do={ /ip hotspot cookie remove [find user=$user];}\r\n:if ([:len [/ip hotspot user find user=$user]]>0) do={ /ip hotspot user remove [find name=$user];}\r\n:if ([:len [/file find name=\"$hotspotFolder/data/$macNoCol\"]]>0) do={ /file remove \"$hotspotFolder/data/$macNoCol\";}\r\n:if ([:len [/system scheduler find name=$user]]>0) do={ /system scheduler remove [find name=$user];}\r\n"
  } else={ 
    :local currentInterval [/system scheduler get $user interval];
    :local newInterval ($currentInterval+$validity)
    /system scheduler set $user interval $newInterval;
  };
  # :log info "creating scheduler success"; #debug 

  :set $validUntil [/system scheduler get $user next-run];

  #show validity on portal
  # :log info "creating file to show expiration on portal"; #debug
  /file print file="$hotspotFolder/data/$macNoCol" where name="dummyfile";
  :delay 1s;
  /file set "$hotspotFolder/data/$macNoCol" contents="$user#$validUntil";
  # :log info "creating file to show expiration on portalsuccess"; #debug

  #update sales
  #daily sales
  # :log info "updating todayincome"; #debug
  # :if ([:len [/system script find name~"todayincome"]]=0) do={ /system script add name=todayincome source="0";delay 2s;}
  :local currenttodayincome [/system script get [find name=todayincome] source];
  :local newtodayincome ($amt + $currenttodayincome);
  /system script set todayincome source="$newtodayincome";
  #monthly sales
  # :log info "updating monthlyincome"; #debug
  # :if ([:len [/system script find name~"monthlyincome"]]=0) do={ /system script add name=monthlyincome source="0";delay 2s;}
  :local currentmonthlyincome [/system script get [find name=monthlyincome] source];
  :local newmonthlyincome ($amt + $currentmonthlyincome);
  /system script set monthlyincome source="$newmonthlyincome";
  # :log info "sales update success"; #debug

  #Daily Sales Report
  # :if ([len [/system scheduler find name~"Sales Report"]]=0) do={ /system scheduler add name="test" start-time=23:00:00 start-date=[/system clock get date] interval=24:00:00 on-event="put \"hello world\"";}



  # delete hotspot user comment
  # :log info "removing info"; #debug
  /ip hotspot user set comment="" $user;

  #set telegram message new sale
  # :log info "telegram notification"; #debug
  :if ($enableTelegram = true) do={ 
    :local message "Vendo: $vendo %0AVoucher: $user %0AAmount: $amt %0AExpiration: $validUntil %0A%0AActive Users: $activeUsers";
    /tool fetch keep-result=no url=("https://api.telegram.org/bot".$botToken."/sendmessage\?chat_id=".$chatID."&text=".$message);
  }
}

#fix random mac
# :log info "random max fix"; #debug
:foreach activeUser in=[/ip hotspot active find user="$user"] do={ 
  :local currentMac $"mac-address"
  :local oldMac [/ip hotspot active get $activeUser mac-address];
  :if ($currentMac!=$oldMac) do={ 
    /ip hotspot active remove [/ip hotspot active find mac-address="$oldMac"];
  }
}
# :log info "random max fix success"; #debug