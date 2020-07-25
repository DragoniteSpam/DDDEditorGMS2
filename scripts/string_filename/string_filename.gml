/// @param str
// removes all invalid characters for a filename (plus whitespace) and
// replaces them with a hyphen

var str = argument0;

regex_setexpression("[<>:\"\\/\\\\|?*\\s]");
regex_setinput(str);
return regex_replace("-");