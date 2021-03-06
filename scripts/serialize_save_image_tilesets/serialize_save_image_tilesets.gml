/// @param buffer
function serialize_save_image_tilesets(argument0) {

    var buffer = argument0;

    buffer_write(buffer, buffer_u32, SerializeThings.IMAGE_TILESET);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);

    var n_tilesets = ds_list_size(Stuff.all_graphic_tilesets);
    buffer_write(buffer, buffer_u16, n_tilesets);

    for (var i = 0; i < n_tilesets; i++) {
        var ts = Stuff.all_graphic_tilesets[| i];
    
        // don't use save_generic here because flags is overridden and is now
        // an array, which will break things
        buffer_write(buffer, buffer_string, ts.name);
        buffer_write(buffer, buffer_string, ts.internal_name);
        buffer_write(buffer, buffer_string, ts.summary);
        buffer_write(buffer, buffer_datatype, ts.GUID);
    
        buffer_write(buffer, buffer_string, ts.picture_name);
    
        // stash the sprite in the buffer (via surface)
        buffer_write_sprite(buffer, ts.picture);
    
        // @todo this stuff should probably be a property of the tileset now
        var n_autotiles = array_length(ts.autotiles);
        buffer_write(buffer, buffer_u8, n_autotiles);
    
        for (var j = 0; j < n_autotiles; j++) {
            // s16 because no tile is "noone"
            buffer_write(buffer, buffer_s16, ts.autotiles[j]);
            buffer_write(buffer, buffer_u32, ts.at_flags[j]);
        }
    
        // all of these grids will be the same dimensions so the
        // data can be saved in one loop
    
        var t_grid_width = ds_grid_width(ts.flags);
        var t_grid_height = ds_grid_height(ts.flags);
    
        buffer_write(buffer, buffer_u16, t_grid_width);
        buffer_write(buffer, buffer_u16, t_grid_height);
    
        for (var j = 0; j < t_grid_width; j++) {
            for (var k = 0; k < t_grid_height; k++) {
                buffer_write(buffer, buffer_u32, ts.flags[# j, k]);
            }
        }
    }

    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

    return buffer_tell(buffer);


}
