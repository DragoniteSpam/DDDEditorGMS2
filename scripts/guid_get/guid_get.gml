/// @param guid

if (ds_map_exists(Stuff.all_guids, argument0)) {
    return Stuff.all_guids[? argument0];
}

return noone;