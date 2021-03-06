function serialize_save_map_contents_zones(buffer) {
    // this was originally supposed to be only entities not marked as "static,"
    // but it became obvious that wasn't going to work pretty quickly, so now
    // they're all entities that haven't been baked together. the
    // save_map_contents_static has been renamed to save_map_contents_batch to
    // avoid confusion.
    
    buffer_write(buffer, buffer_u32, SerializeThings.MAP_ZONES);
    var addr_skip = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var n_zones = ds_list_size(Stuff.map.active_map.contents.all_zones);
    buffer_write(buffer, buffer_u32, n_zones);

    for (var i = 0; i < n_zones; i++) {
        var zone = Stuff.map.active_map.contents.all_zones[| i];
        buffer_write(buffer, buffer_u16, zone.ztype);
        script_execute(zone.save_script, buffer, zone);
    }
    
    buffer_poke(buffer, addr_skip, buffer_u64, buffer_tell(buffer));
}