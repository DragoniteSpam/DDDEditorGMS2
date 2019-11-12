/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.IMAGE_MISC);
var list = Stuff.all_graphic_etc;

var n_images = ds_list_size(list);
buffer_write(buffer, buffer_u32, n_images);

for (var i = 0; i < n_images; i++) {
    var data = list[| i];
    
    serialize_save_generic(buffer, data);
    buffer_write(buffer, buffer_u16, data.hframes);
    buffer_write(buffer, buffer_u16, data.vframes);
    buffer_write_sprite(buffer, data.picture);
    // misc images may need to be summoned on-the-fly; in the future they may be
    // slapped onto one single texture page but for now they won't be
}

return buffer_tell(buffer);