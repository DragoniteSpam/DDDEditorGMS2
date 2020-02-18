/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.IMAGE_BATTLERS);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);
var list = Stuff.all_graphic_battlers;

var n_images = ds_list_size(list);
buffer_write(buffer, buffer_u32, n_images);

for (var i = 0; i < n_images; i++) {
    var data = list[| i];
    
    serialize_save_generic(buffer, data);
    buffer_write(buffer, buffer_u16, data.hframes);
    buffer_write(buffer, buffer_u16, data.vframes);
    
    buffer_write_sprite(buffer, data.picture);
    // battlers and overworlds aren't stored on a texture page ahead
    // of time - those are created for each map when the map is loaded
    // or when the battle starts
    
    var bools = pack(data.texture_exclude);
    buffer_write(buffer, buffer_u32, bools);
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);