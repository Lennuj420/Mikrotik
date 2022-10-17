#Program Name: scriptToArray
#Author: junnel verceluz
#Version: 1
#Description: Parses script and outputs all the data as array to be used by other scripts. (Please Follow the Specific format)
#Dependencies: none

{
    :local outputArray ({});
    :local tempArray [toarray  [/system script get $1 source]];

    :for i from=0 to=([len $tempArray]-1) do={
        :local currentIndex [pick $tempArray $i];
        :local separator [find $currentIndex "="];
        :local currentKey [pick $currentIndex 0 $separator];
        :local currentValue [pick $currentIndex ($separator+1) [len $currentIndex]];
        if ($i != ([len $tempArray]-1)) do={
        :set $currentValue [pick $currentValue 0 ([len $currentValue]-2)]
        }
        :set ($outputArray->$currentKey) $currentValue;
    }
    :return ($outputArray);
}