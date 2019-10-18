/// @param buffer
/// @param version

var version = argument1;

var n_autotiles = buffer_read(argument0, buffer_u16);
// garbage collection is great
Stuff.all_graphic_autotiles = array_create(n_autotiles);

for (var i = 0; i < n_autotiles; i++) {
    var exists = buffer_read(argument0, buffer_u8);
    
    if (exists) {
        var at_picture = buffer_read_sprite(argument0);
        // no longer needed
        var at_name = buffer_read(argument0, buffer_string);
        var at_deleteable = buffer_read(argument0, buffer_u8);
        var at_filename = buffer_read(argument0, buffer_string);
        var at_frames = buffer_read(argument0, buffer_u8);
        var at_width = buffer_read(argument0, buffer_u8);
        
        Stuff.all_graphic_autotiles[i] = [at_picture, at_name, at_deleteable, at_filename, at_frames, at_width];
    } else {
        Stuff.all_graphic_autotiles[i] = noone;
    }
}