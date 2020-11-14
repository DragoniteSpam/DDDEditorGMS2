function serialize_load_map_contents_zones(buffer, version, map_container) {
    if (version >= DataVersions.MAP_SKIP_ADDRESSES) {
        var skip_addr = buffer_read(buffer, buffer_u64);
    }
    
    var n_zones = buffer_read(buffer, buffer_u32);
    
    repeat (n_zones) {
        var type = buffer_read(buffer, buffer_u16);
        var thing = instance_create_depth(0, 0, 0, global.map_zone_type_objects[type]);
        script_execute(thing.load_script, buffer, thing, version);
    }
}