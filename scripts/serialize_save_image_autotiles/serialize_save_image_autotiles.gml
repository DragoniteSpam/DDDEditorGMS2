/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.IMAGE_AUTOTILES);

var n_autotiles = ds_list_size(Stuff.all_graphic_autotiles);
buffer_write(buffer, buffer_u16, n_autotiles);

for (var i = 0; i < n_autotiles; i++) {
    var at = Stuff.all_graphic_autotiles[| i];
    
    var exists = is_array(at);
    
    buffer_write(buffer, buffer_u8, exists);
    
    if (exists) {
        buffer_write_sprite(buffer, at[@ AvailableAutotileProperties.PICTURE]);
        // this no longer needs to be written - it would be the (built-in) sprite index of
        //the autotile, but that goes out the window when they're being loaded from the file
        buffer_write(buffer, buffer_string, at[@ AvailableAutotileProperties.NAME]);
        buffer_write(buffer, buffer_u8, at[@ AvailableAutotileProperties.DELETEABLE]);
        buffer_write(buffer, buffer_string, at[@ AvailableAutotileProperties.FILENAME]);
        buffer_write(buffer, buffer_u8, at[@ AvailableAutotileProperties.FRAMES]);
        buffer_write(buffer, buffer_u8, at[@ AvailableAutotileProperties.WIDTH]);
    }
}