#ask user input, store it in variable
:put "please enter your name";
:global read do={:return};

#store to variable
:global myVar [$read];

#show value of the variable in terminal
:put $myVar;