function refid_set(data, refid, map_container) {
    if (map_container == undefined) map_container = Stuff.map.active_map;
    
    if (!map_container.contents.refids[? refid]) map_container.contents.refids[? refid] = data;
    data.REFID = refid;
}