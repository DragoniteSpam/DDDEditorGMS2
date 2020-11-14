function serialize_save_map_contents_dynamic(buffer) {
    // this was originally supposed to be only entities not marked as "static,"
    // but it became obvious that wasn't going to work pretty quickly, so now
    // they're all entities that haven't been baked together. the
    // save_map_contents_static has been renamed to save_map_contents_batch to
    // avoid confusion.
    
    buffer_write(buffer, buffer_u32, SerializeThings.MAP_DYNAMIC);
    var addr_skip = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var n_things = ds_list_size(Stuff.map.active_map.contents.all_entities);
    buffer_write(buffer, buffer_u32, n_things);
    
    for (var i = 0; i < n_things; i++) {
        var thing = Stuff.map.active_map.contents.all_entities[| i];
        buffer_write(buffer, buffer_u16, thing.etype);
        buffer_write(buffer, buffer_u32, thing.tmx_id);
        script_execute(thing.save_script, buffer, thing);
    }
    
    buffer_poke(buffer, addr_skip, buffer_u64, buffer_tell(buffer));
}