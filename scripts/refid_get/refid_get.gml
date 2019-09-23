/// @param refid

if (ds_map_exists(Stuff.active_map.contents.all_refids, argument0)) {
    return Stuff.active_map.contents.all_refids[? argument0];
}

return noone;