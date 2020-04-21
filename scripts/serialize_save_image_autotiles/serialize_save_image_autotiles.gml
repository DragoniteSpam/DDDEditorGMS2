/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_u32, SerializeThings.IMAGE_TILE_ANIMATION);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);

var n_autotiles = ds_list_size(Stuff.all_graphic_autotiles);
buffer_write(buffer, buffer_u16, n_autotiles);

for (var i = 0; i < n_autotiles; i++) {
    var data = Stuff.all_graphic_autotiles[| i];
    
    buffer_write_sprite(buffer, data.picture);
    buffer_write(buffer, buffer_string, data.name);
    buffer_write(buffer, buffer_u8, data.aframes);
    buffer_write(buffer, buffer_f32, data.aspeed);
    
    var bools = pack(data.texture_exclude);
    buffer_write(buffer, buffer_u32, bools);
    
    buffer_write(buffer, buffer_u16, data.width);
    buffer_write(buffer, buffer_u16, data.height);
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);