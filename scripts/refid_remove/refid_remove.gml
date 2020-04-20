/// @param refid
/// @param [map]

var refid = argument[0];
var map = (argument_count > 1 && argument[1] != undefined) ? argument[1] : Stuff.map.active_map;

if (ds_map_exists(map.contents.refids, refid)) {
    ds_map_delete(map.contents.refids, refid);
    return true;
}

return false;