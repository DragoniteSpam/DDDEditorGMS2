/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;
var list = Stuff.all_graphic_etc;

ds_list_clear_instances(list);

var n_images = buffer_read(buffer, buffer_u16);

repeat (n_images) {
    var data = instance_create_depth(0, 0, 0, DataImage);
    
    serialize_load_generic(buffer, data, version);
    data.hframes = buffer_read(buffer, buffer_u16);
    data.vframes = buffer_read(buffer, buffer_u16);
    data.picture = buffer_read_sprite(buffer);
    
    ds_list_add(list, data);
}