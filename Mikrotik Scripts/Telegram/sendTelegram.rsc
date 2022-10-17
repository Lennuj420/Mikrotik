#Program Name: send Telegram
#Author: junnel verceluz
#Version: 1
#Description: mikrotik script that will send a message to telegram with the given parameters

#dependencies: scriptToArray.rsc, telegramCredentials

# :log info "importing script"; #debug
#import scrptToArray Script
:local scriptToArray [:parse [/system script get scriptToArray source]]

# :log info "script imported"; #debug

#variables
:local telegram ({});
:local telegram [$scriptToArray "telegramCredentials"];
# :log info "$telegram"; #debug
# :log info ($telegram-> token); #debug
:local chatName $1;
# :log info "$1"; #debug
:local message $2;
# :log info "$2"; #debug

# :log info ("https://api.telegram.org/bot".($telegram->"botToken")."/sendmessage\?chat_id=".($telegram->$chatName)."&text=$message"); #debug

# :log info "sending telegram"; #debug
#send message
/tool fetch keep-result=no url=("https://api.telegram.org/bot".($telegram->"botToken")."/sendmessage\?chat_id=".($telegram->$chatName)."&text=$message");
# :log info "telegram sent"; #debug