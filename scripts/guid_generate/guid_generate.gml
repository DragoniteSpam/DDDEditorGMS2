var n = NULL;

do {
    // range: [1, 2147483647] - 0 is "null"
    n = string_hex(irandom(0x7ffffffe) + 1);
} until (!ds_map_exists(Stuff.all_guids, n));

return n;