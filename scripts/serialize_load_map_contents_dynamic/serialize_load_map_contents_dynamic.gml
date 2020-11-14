function serialize_load_map_contents_dynamic(buffer, version, map_container, is_temp) {
    if (is_temp == undefined) is_temp = false;
    
    if (version >= DataVersions.MAP_SKIP_ADDRESSES) {
        var skip_addr = buffer_read(buffer, buffer_u64);
    }
    
    var n_things = buffer_read(buffer, buffer_u32);
    
    repeat (n_things) {
        var type = buffer_read(buffer, buffer_u16);
        var thing = instance_create_depth(0, 0, 0, global.etype_objects[type]);
        thing.tmx_id = buffer_read(buffer, buffer_u32);
        script_execute(thing.load_script, buffer, thing, version);
        
        // some things don't need to exist in the map grid
        if (thing.exist_in_map) {
            map_add_thing(thing, thing.xx, thing.yy, thing.zz, map_container, is_temp);
        }
    }
}