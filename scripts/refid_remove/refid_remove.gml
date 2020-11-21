function refid_remove(entity, map) {
    if (map == undefined) map = Stuff.map.active_map;
    
    if (map.contents.refids[? entity.REFID] == entity) {
        ds_map_delete(map.contents.refids, entity.REFID);
        return true;
    }

    return false;
}