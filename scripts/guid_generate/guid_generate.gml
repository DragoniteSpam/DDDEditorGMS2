function guid_generate() {
    do {
        var n = Stuff.game_asset_id + ":" + string_hex(Stuff.guid_current++, 8);
    } until (!ds_map_exists(Stuff.all_guids, n));

    return  n;


}
