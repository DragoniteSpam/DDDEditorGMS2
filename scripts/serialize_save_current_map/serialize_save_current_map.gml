var buffer = buffer_create(1024, buffer_grow, 1);

serialize_save_map_contents_meta(buffer);    
serialize_save_map_contents_batch(buffer);
serialize_save_map_contents_dynamic(buffer);

buffer_write(buffer, buffer_datatype, SerializeThings.END_OF_FILE);

buffer_resize(buffer, buffer_tell(buffer));

return buffer;