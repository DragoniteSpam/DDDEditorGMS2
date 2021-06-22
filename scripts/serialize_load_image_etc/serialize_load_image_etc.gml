/// @param buffer
/// @param version
function serialize_load_image_etc(argument0, argument1) {

    var buffer = argument0;
    var version = argument1;
    var list = Game.graphics.etc;

    var addr_next = buffer_read(buffer, buffer_u64);

    var n_images = buffer_read(buffer, buffer_u32);

    repeat (n_images) {
        var data = new DataImage();
    
        serialize_load_generic(buffer, data, version);
        data.hframes = buffer_read(buffer, buffer_u16);
        data.vframes = buffer_read(buffer, buffer_u16);
        data.aspeed = buffer_read(buffer, buffer_f32);
        data.picture = buffer_read_sprite(buffer);
        var bools = buffer_read(buffer, buffer_u32);
        data.texture_exclude = unpack(bools, 0);
    
        data.width = buffer_read(buffer, buffer_u16);
        data.height = buffer_read(buffer, buffer_u16);
    
        array_push(list, data);
    }


}
