do {
    var n = string_hex(irandom(0x7fffffff));
} until (!ds_map_exists(Stuff.all_guids, n));

return n;