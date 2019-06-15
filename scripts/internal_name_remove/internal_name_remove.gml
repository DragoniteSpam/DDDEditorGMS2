/// @param guid

if (ds_map_exists(Stuff.all_internal_names, argument0)) {
    ds_list_delete(Stuff.all_internal_names, argument0);
    return true;
}

return false;
