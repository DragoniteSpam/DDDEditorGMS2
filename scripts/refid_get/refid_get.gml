/// @param refid

if (ds_map_exists(Stuff.all_refids, argument0)) {
    return Stuff.all_refids[? argument0];
}

return noone;