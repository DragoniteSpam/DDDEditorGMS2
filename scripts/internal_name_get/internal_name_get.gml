/// @param name
function internal_name_get(argument0) {

    if (ds_map_exists(Stuff.all_internal_names, argument0)) {
        return Stuff.all_internal_names[? argument0];
    }

    return noone;


}
