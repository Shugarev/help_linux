# https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

# ${parameter:-word}
# If parameter is unset or null, the expansion of word is substituted. Otherwise, the value of parameter is substituted. 
v=123
echo ${v-unset}
#123

${parameter:=word}
# parameter is unset or null, the expansion of word is assigned to parameter. The value of parameter is then substituted. Positional parameters and special parameters may not be assigned to in this way. 
var=
${var:=DEFAULT}
echo $var
#DEFAULT

${parameter:?word}
# If parameter is null or unset, the expansion of word (or a message to that effect if word is not present) is written to the standard error and the shell, if it is not interactive, exits. Otherwise, the value of parameter is substituted. 

var=123
echo ${var:+var is set and not null}
# var is set and not null

${parameter:offset}
${parameter:offset:length}
# This is referred to as Substring Expansion. 
string=01234567890abcdefgh
echo ${string:7}
#7890abcdefgh

string=01234567890abcdefgh
echo ${string:7:3}
#789


# replace
var=abcdef
rep='& '
echo ${var/abc/& }
echo "${var/abc/& }"
echo ${var/abc/$rep}
echo "${var/abc/$rep}"
#& def

var=abcdef
rep='\\&xyz'
echo ${var/abc/\\&xyz}
echo ${var/abc/$rep}
#\&xyzdef