/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;
var list = Stuff.all_graphic_overworlds;

var addr_next = buffer_read(buffer, buffer_u64);

ds_list_clear_instances(list);

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
    
    data_image_force_power_two(data);
    data_image_npc_frames(data);
    
    ds_list_add(list, data);
}