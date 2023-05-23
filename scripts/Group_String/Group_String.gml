function string_comma(n) {
    // this is a very lazy solution and won't work in all cases.
    // decimals, for example, completely screw it up.
    //    5000 =>      5000
    //   15000 =>    15,000
    // 3850000 => 3,850,000
    var str = string(n);
    var len = string_length(str);
    if (len <= 4 || len > 9) return str;
    
    var fstr = "";
    for (var i = len; i > 0; i--) {
        fstr = string_char_at(str, i) + fstr;
        if ((len - i) % 3 == 2 && i > 1) {
            fstr = "," + fstr;
        }
    }
    
    return fstr;
}

function string_filename(str) {
    // removes all invalid characters for a filename (plus whitespace) and
    // replaces them with a hyphen
    static invalid_characters = ["<", ">", ":", "\"", "/", "\\", "|", "?", "*", " ", "\n"];
    for (var i = 0, n = array_length(invalid_characters); i < n; i++) {
        str = string_replace_all(str, invalid_characters[i], "-");
    }
    return str;
}

/// @param value
/// @param [pad=0]
function string_hex(value) {
    value = argument[0];
    var padding = (argument_count > 1) ? argument[1] : 0;
    
    var s = sign(value);
    var v = abs(value);
    
    var output = "";
    
    while (v > 0)  {
        var c  = v & 0xf;
        output = chr(c + ((c < 10) ? 48 : 55)) + output;
        v = v >> 4;
    }
    
    if (string_length(output) == 0) output = "0";
    
    return ((s < 0) ? "-" : "") + string_pad(output, "0", padding);
}

/// @param value
/// @param char
/// @param n
function string_pad() {
    var value = string(argument[0]);
    var char = argument[1];
    var padding = (argument_count > 2) ? argument[2] : 0;
    
    while (string_length(value) < padding) {
        value = char + value;
    }
    
    return value;
}