/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var addr_next = buffer_read(buffer, buffer_u64);

var n_autotiles = buffer_read(buffer, buffer_u16);

for (var i = 0; i < n_autotiles; i++) {
    var data = instance_create_depth(0, 0, 0, DataImageAutotile);
    
    data.picture = buffer_read_sprite(buffer);
    data.name = buffer_read(buffer, buffer_string);
    data.aframes = buffer_read(buffer, buffer_u8);
    data.aspeed = buffer_read(buffer, buffer_f32);
    var bools = buffer_read(buffer, buffer_u32);
    data.texture_exclude = unpack(bools, 0);
    data.width = buffer_read(buffer, buffer_u16);
    data.height = buffer_read(buffer, buffer_u16);
    
    ds_list_add(Stuff.all_graphic_autotiles, data);
}