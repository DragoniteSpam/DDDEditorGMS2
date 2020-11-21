function refid_get(refid, map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    return map_container.contents.refids[$ refid];
}