function serialize_load_image_tile_animations(buffer, version) {
    var list = Game.graphics.tile_animations;
    
    var addr_next = buffer_read(buffer, buffer_u64);
    var n_images = buffer_read(buffer, buffer_u32);
    repeat (n_images) {
        var data = instance_create_depth(0, 0, 0, DataImage);
        
        serialize_load_generic(buffer, data, version);
        
        data.hframes = buffer_read(buffer, buffer_u16);
        data.vframes = buffer_read(buffer, buffer_u16);
        data.aspeed = buffer_read(buffer, buffer_f32);
        data.picture = buffer_read_sprite(buffer);
        
        var bools = buffer_read(buffer, buffer_u32);
        data.texture_exclude = unpack(bools, 0);
        data.width = buffer_read(buffer, buffer_u16);
        data.height = buffer_read(buffer, buffer_u16);
        
        ds_list_add(list, data);
    }
}