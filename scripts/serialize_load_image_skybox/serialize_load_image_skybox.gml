/// @param buffer
/// @param version
function serialize_load_image_skybox(argument0, argument1) {

    var buffer = argument0;
    var version = argument1;
    var list = Game.graphics.skybox;

    var addr_next = buffer_read(buffer, buffer_u64);
    
    var n_images = buffer_read(buffer, buffer_u32);

    repeat (n_images) {
        var data = new DataImage();
    
        serialize_load_generic(buffer, data, version);
        data.x = buffer_read(buffer, buffer_f32);
        data.y = buffer_read(buffer, buffer_f32);
        data.width = buffer_read(buffer, buffer_f32);
        data.height = buffer_read(buffer, buffer_f32);
    
        var bools = buffer_read(buffer, buffer_u32);
    
        data.picture = buffer_read_sprite(buffer);
    
        array_push(list, data);
    }


}
