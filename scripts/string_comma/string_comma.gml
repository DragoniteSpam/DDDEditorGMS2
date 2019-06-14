/// @param n
// this is a very lazy solution and won't work in all cases. decimals, for example,
// completely screw it up.

//    5000 =>      5000
//   15000 =>    15,000
// 3850000 => 3,850,000

var str = string(argument0);
var len = string_length(str);
if (len <= 4 || len > 9) {
    return str;
}

var fstr = "";
for (var i = len; i > 0; i--) {
    fstr = string_char_at(str, i) + fstr;
    if ((len - i) % 3 == 2 && i > 1) {
        fstr = "," + fstr;
    }
}

return fstr;