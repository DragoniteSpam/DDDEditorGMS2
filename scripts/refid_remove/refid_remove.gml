function refid_remove(entity, map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    
    if (map_container.contents.refids[$ entity.REFID] == entity) {
        variable_struct_remove(map_container.contents.refids, entity.REFID);
        return true;
    }

    return false;
}