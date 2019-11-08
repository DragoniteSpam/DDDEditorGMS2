/// @param refid

if (ds_map_exists(Stuff.map.active_map.contents.all_refids, argument0)) {
    return Stuff.map.active_map.contents.all_refids[? argument0];
}

return noone;