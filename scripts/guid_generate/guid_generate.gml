var n = 0;

do {
    // range: [1, 2147483647] - 0 is "null"
    n = irandom(0x7ffffffe) + 1;
} until (!ds_map_exists(Stuff.all_guids, n));

return n;