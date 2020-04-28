/// @param [map]

var map = (argument_count > 0 && argument[0] != undefined) ? argument[0] : Stuff.map.active_map;

do {
    var n = Stuff.game_asset_id + ":" + string_hex(map.contents.refid_current++, 8);
} until (!ds_map_exists(map.contents.refids, n));

return n;