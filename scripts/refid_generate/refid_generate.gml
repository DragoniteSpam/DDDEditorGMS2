var n = 0;

do {
    // range: [1, 2147483647] - 0 is "null"
    n = irandom((1 << 31) - 2) + 1;
} until (!ds_map_exists(Stuff.active_map.contents.all_refids, n));

return n;