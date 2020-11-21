function refid_generate(map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    
    do {
        var n = Stuff.game_asset_id + ":" + string_hex(map_container.contents.refid_current++, 8);
    } until (!map_container.contents.refids[$ n]);
    
    return n;
}