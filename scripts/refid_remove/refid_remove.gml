/// @param refid

if (ds_map_exists(Stuff.active_map.contents.all_refids, argument0)) {
    ds_list_delete(Stuff.active_map.contents.all_refids, argument0);
    return true;
}

return false;