/// @param guid

var value = argument0;

if (ds_map_exists(Stuff.all_guids, value)) {
    return Stuff.all_guids[? value];
}

return noone;