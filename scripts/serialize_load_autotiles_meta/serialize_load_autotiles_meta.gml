/// @description  void serialize_load_autotiles_meta(buffer, version);
/// @param buffer
/// @param  version

var version=argument1;

var n_autotiles=buffer_read(argument0, buffer_u16);
// garbage collection is great
Stuff.available_autotiles=array_create(n_autotiles);

for (var i=0; i<n_autotiles; i++){
    var exists=buffer_read(argument0, buffer_u8);
    
    if (exists){
        var at_picture=buffer_read(argument0, buffer_u16);
        var at_name=buffer_read(argument0, buffer_string);
        var at_deleteable=buffer_read(argument0, buffer_u8);
        var at_filename=buffer_read(argument0, buffer_string);
        var at_frames=buffer_read(argument0, buffer_u8);
        var at_width=buffer_read(argument0, buffer_u8);
        
        if (at_deleteable){
            at_picture=sprite_add_autotile(at_filename);
            if (!sprite_exists(at_picture)){
                at_picture=b_at_default_error;
                error_log("Missing autotile image; using default autotile instead: "+at_filename);
            }
        }
        
        Stuff.available_autotiles[i]=array_compose(at_picture, at_name, at_deleteable, at_filename, at_frames, at_width);
    } else {
        Stuff.available_autotiles[i]=noone;
    }
}
