function serialize_save_map_contents_batch(buffer) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    buffer_write(buffer, buffer_u32, SerializeThings.LANGUAGE_TEXT);
    var addr_skip = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    // do all the stuff here
    
    buffer_poke(buffer, addr_skip, buffer_u64, buffer_tell(buffer));
}