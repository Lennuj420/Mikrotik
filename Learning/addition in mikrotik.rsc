#declare variable and set a value
:local var1 5;

#set a new value of the variable
:set $var1 ($var1 + 1);
#after this line, var1 is now 6

#display value of a variable to terminal
:put $var1;
