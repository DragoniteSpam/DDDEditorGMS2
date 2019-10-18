/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.IMAGE_BATTLERS);
var list = Stuff.all_graphic_battlers;

var n_images = ds_list_size(list);
buffer_write(buffer, buffer_u16, n_images);

for (var i = 0; i < n_images; i++) {
    var data = list[| i];
    
    serialize_save_generic(buffer, data);
    buffer_write(buffer, buffer_u16, data.hframes);
    buffer_write(buffer, buffer_u16, data.vframes);
    buffer_write_sprite(buffer, data.picture);
    // battlers and overworlds aren't stored on a texture page ahead
    // of time - those are created for each map when the map is loaded
    // or when the battle starts
}