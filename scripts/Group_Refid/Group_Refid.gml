function refid_remove(entity, map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    
    if (map_container.contents.refids[$ entity.REFID] == entity) {
        variable_struct_remove(map_container.contents.refids, entity.REFID);
        return true;
    }

    return false;
}

function refid_generate(map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    var n;
    do {
        n = Game.meta.project.id + ":" + string_hex(map_container.contents.refid_current++, 8);
    } until (!map_container.contents.refids[$ n]);
    
    return n;
}

function refid_get(refid, map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    return map_container.contents.refids[$ refid];
}

function refid_set(data, refid, map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    
    if (!map_container.contents.refids[$ refid]) map_container.contents.refids[$ refid] = data;
    data.REFID = refid;
}