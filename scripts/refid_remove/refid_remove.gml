/// @param refid

var refID = argument0;

if (ds_map_exists(Stuff.map.active_map.contents.all_refids, refID)) {
    ds_map_exists(Stuff.map.active_map.contents.all_refids, refID);
    return true;
}

return false;