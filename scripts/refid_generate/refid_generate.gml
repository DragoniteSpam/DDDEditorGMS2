/// @param [map]

var map = (argument_count > 0 && argument[0] != undefined) ? argument[0] : Stuff.map.active_map;

do {
    var n = string_hex(map.contents.refid_current++);
} until (!ds_map_exists(map.contents.refids, n));

return n;