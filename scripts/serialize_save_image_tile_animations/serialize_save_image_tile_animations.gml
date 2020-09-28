/// @param buffer
function serialize_save_image_tile_animations(argument0) {

    var buffer = argument0;

    buffer_write(buffer, buffer_u32, SerializeThings.IMAGE_TILE_ANIMATION);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    var list = Stuff.all_graphic_tile_animations;

    var n_images = ds_list_size(list);
    buffer_write(buffer, buffer_u32, n_images);

    for (var i = 0; i < n_images; i++) {
        var data = list[| i];
    
        serialize_save_generic(buffer, data);
        buffer_write(buffer, buffer_u16, data.hframes);
        buffer_write(buffer, buffer_u16, data.vframes);
        buffer_write(buffer, buffer_f32, data.aspeed);
    
        buffer_write_sprite(buffer, data.picture);
    
        var bools = pack(data.texture_exclude);
        buffer_write(buffer, buffer_u32, bools);
    
        buffer_write(buffer, buffer_u16, data.width);
        buffer_write(buffer, buffer_u16, data.height);
    }

    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

    return buffer_tell(buffer);


}
