function bezier_point(t, p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y) {
    /*
     * Lerp is a value from 0-1 to find on the line between p0 and p3
     * p1 and p2 are the control points
     * returns array (x,y)
     *
     * credit: andev on Game Maker forums:
     * https://forum.yoyogames.com/index.php?threads/a-free-simple-quadratic-bezier-curve-script-in-gml.42161/
     */
    
    //Precalculated power math
    var tt  = t  * t;
    var ttt = tt * t;
    var u   = 1  - t; //Inverted
    var uu  = u  * u;
    var uuu = uu * u;
    
    //Calculate the point
    var px =     uuu * p0x; //first term
    var py =     uuu * p0y;
    px += 3 * uu * t * p1x; //second term
    py += 3 * uu * t * p1y;
    px += 3 * u * tt * p2x; //third term 
    py += 3 * u * tt * p2y;
    px +=        ttt * p3x; //fourth term
    py +=        ttt * p3y;
    
    return new Vector2(px, py);
}

function ceil_ext(value, to) {
    return ceil(value / to) * to;
}

function decimal(value) {
    // i tried finding a regex that would do this but none of them would
    // properly handle things like 15.000
    value = string_format(value, 1, 10);
    if (string_count(".", value) == 0) return value;
    
    while (string_char_at(value, string_length(value)) == "0") {
        value = string_copy(value, 1, string_length(value) - 1);
    }
    
    if (string_char_at(value, string_length(value)) == ".") {
        return string_copy(value, 1, string_length(value) - 1);
    }
    
    return value;
}

function floor_ext(value, to) {
    return floor(value / to) * to;
}

function hex(str) {
    var result = 0;
    
    // special unicode values
    static ZERO = ord("0");
    static NINE = ord("9");
    static A = ord("A");
    static F = ord("F");
    
    for (var i = 1; i <= string_length(str); i++) {
        var c = ord(string_char_at(string_upper(str), i));
        // you could also multiply by 16 but you get more nerd points for bitshifts
        result = result << 4;
        // if the character is a number or letter, add the value
        // it represents to the total
        if (c >= ZERO && c <= NINE) {
            result = result + (c - ZERO);
        } else if (c >= A && c <= F) {
            result = result + (c - A + 10);
        // otherwise complain
        } else {
            throw "bad input for hex(str): " + str;
        }
    }
    
    return result;
}

function is_clamped(n, a, b) {
    return clamp(n, a, b) == n;
}

// formerly "normalize" but that was kinda wrong
function adjust_range(n, mn, mx, omin = 0, omax = 1) {
    if (mn == mx && mn == n) return mn;
    return mn + ((n - omin) / (omax - omin)) * (mx - mn);
}

function number_max_digits(n) {
    return log10(max(1, abs(n))) + 1 + ((n < 0) ? 1 : 0);
}

function round_ext(value, to) {
    return round(value / to) * to;
}

function round_power_of_two(n) {
    return power(2, round(log2(n)));
}

function floor_power_of_two(n) {
    return power(2, floor(log2(n)));
}

function ceil_power_of_two(n) {
    return power(2, ceil(log2(n)));
}