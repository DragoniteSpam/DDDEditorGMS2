/// @param refid

if (ds_map_exists(Stuff.all_refids, argument0)) {
    ds_list_delete(Stuff.all_refids, argument0);
    return true;
}

return false;