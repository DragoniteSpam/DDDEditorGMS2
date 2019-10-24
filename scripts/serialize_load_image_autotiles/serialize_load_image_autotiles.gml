/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

var n_autotiles = buffer_read(buffer, buffer_u16);

for (var i = 0; i < n_autotiles; i++) {
    var exists = buffer_read(buffer, buffer_u8);
    
    if (exists) {
        var at_picture = buffer_read_sprite(buffer);
        // no longer needed
        var at_name = buffer_read(buffer, buffer_string);
        var at_deleteable = buffer_read(buffer, buffer_u8);
        var at_filename = buffer_read(buffer, buffer_string);
        var at_frames = buffer_read(buffer, buffer_u8);
        var at_width = buffer_read(buffer, buffer_u8);
        
        ds_list_add(Stuff.all_graphic_autotiles, [at_picture, at_name, at_deleteable, at_filename, at_frames, at_width]);
    } else {
        ds_list_add(Stuff.all_graphic_autotiles, noone);
    }
}