function refid_set(data, refid, map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    
    map_container.contents.refids[? refid] = data;
    data.REFID = refid;
}