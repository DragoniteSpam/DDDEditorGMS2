do {
    var n = string_hex(Stuff.guid_current++);
} until (!ds_map_exists(Stuff.all_guids, n));

return n;