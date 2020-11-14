function serialize_save_current_map() {
    var buffer = buffer_create(1024, buffer_grow, 1);
    
    serialize_save_map_contents_meta(buffer);    
    serialize_save_map_contents_batch(buffer);
    serialize_save_map_contents_dynamic(buffer);
    serialize_save_map_contents_zones(buffer);
    
    buffer_resize(buffer, buffer_tell(buffer));
    
    return buffer;
}