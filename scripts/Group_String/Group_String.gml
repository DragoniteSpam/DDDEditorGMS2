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

/// @param string
/// @param [delimiter]
/// @param [enqueue-delimiter?]
/// @param [enqueue-blank?]
function split() {
    var base = argument[0];
    var delimiter = (argument_count > 1) ? argument[1] : " ";
    var enqueue_delimiter = (argument_count > 2) ? argument[2] : false;
    var enqueue_blank = (argument_count > 3) ? argument[3] : false;
    
    var queue = ds_queue_create();
    var tn = "";
    
    base += string_char_at(delimiter, 1);         // lazy way of ensuring the last term in the list does not get skipped
    
    for (var i = 1; i <= string_length(base); i++) {
        var c = string_char_at(base, i);
        var previous = string_char_at(base, i - 1);
        var is_break_char = false;
        for (var j = 1; j <= string_length(delimiter); j++) {
            if (string_char_at(delimiter, j) == c && previous != "\\") {
                if (string_length(tn) > 0 || enqueue_blank) {
                    ds_queue_enqueue(queue, tn);
                }
                if (enqueue_delimiter) {
                    ds_queue_enqueue(queue, string_char_at(delimiter, j));
                }
                tn = "";
                is_break_char = true;
                break;
            }
        }
        if (!is_break_char) tn = tn + c;
    }
    
    // because i did a dumb way of adding the first term
    if (ds_queue_size(queue) == 1 && string_length(ds_queue_head(queue)) == 0) {
        ds_queue_clear(queue);
    }
    
    return queue;
}