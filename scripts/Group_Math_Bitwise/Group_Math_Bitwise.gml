/// @param bools...
function pack() {
    var n = 0;
    for (var i = 0; i < argument_count; i++) {
        n |= argument[i] << i;
    }
    return n;
}

function unpack(field, n) {
    return !!(field & (1 << n));
}