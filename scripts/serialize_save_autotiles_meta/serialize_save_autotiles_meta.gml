/// @description void serialize_save_autotiles_meta(buffer);
/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.AUTOTILES_META);

var n_autotiles=array_length_1d(Stuff.available_autotiles);
buffer_write(argument0, buffer_u16, n_autotiles);

for (var i=0; i<n_autotiles; i++) {
    var at=Stuff.available_autotiles[i];
    
    var exists=is_array(at);
    
    buffer_write(argument0, buffer_u8, exists);
    
    if (exists) {
        buffer_write(argument0, buffer_u16, at[@ AvailableAutotileProperties.PICTURE]);
        buffer_write(argument0, buffer_string, at[@ AvailableAutotileProperties.NAME]);
        buffer_write(argument0, buffer_u8, at[@ AvailableAutotileProperties.DELETEABLE]);
        buffer_write(argument0, buffer_string, at[@ AvailableAutotileProperties.FILENAME]);
        buffer_write(argument0, buffer_u8, at[@ AvailableAutotileProperties.FRAMES]);
        buffer_write(argument0, buffer_u8, at[@ AvailableAutotileProperties.WIDTH]);
    }
}
