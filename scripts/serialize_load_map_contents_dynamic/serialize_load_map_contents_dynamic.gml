function serialize_load_map_contents_dynamic(buffer, version, map_container, is_temp, list_only) {
    if (is_temp == undefined) is_temp = false;
    if (list_only == undefined) list_only = false;
    
    if (list_only) {
        buffer_seek(buffer, buffer_seek_start, 0);
        // metadata
        buffer_read(buffer, buffer_u32);
        var skip_addr = buffer_read(buffer, buffer_u64);
        buffer_seek(buffer, buffer_seek_start, skip_addr);
        // batch
        buffer_read(buffer, buffer_u32);
        var skip_addr = buffer_read(buffer, buffer_u64);
        buffer_seek(buffer, buffer_seek_start, skip_addr);
        // dynamic entities
        buffer_read(buffer, buffer_u32);
    }
    
    var skip_addr = buffer_read(buffer, buffer_u64);
    var n_things = buffer_read(buffer, buffer_u32);
    var entities = array_create(n_things);
    var n = 0;
    
    repeat (n_things) {
        var type = buffer_read(buffer, buffer_u16);
        var thing = instance_create_depth(0, 0, 0, global.etype_objects[type]);
        thing.tmx_id = buffer_read(buffer, buffer_u32);
        thing.load_script(buffer, thing, version);
        
        // some things don't need to exist in the map grid
        if (thing.exist_in_map && !list_only) {
            map_container.Add(thing, thing.xx, thing.yy, thing.zz, is_temp);
        }
        
        entities[n++] = thing;
    }
    
    return entities;
}