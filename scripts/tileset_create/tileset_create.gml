/// @param file/name
/// @param [autotiles]
/// @param [sprite-index]

// don't instantiate these outside of this script
with (instance_create_depth(0, 0, 0, DataTileset)) {
    picture_name = argument[0];
    
    internal_name_generate(id, PREFIX_GRAPHIC_TILESET + string_lettersdigits(picture_name));
    
    autotiles = (argument_count > 1) ? argument[1] : autotiles;
    
    if (argument_count > 2) {
        picture = argument[2];
    } else {
        picture = sprite_add(argument[0], 0, false, false, 0, 0);
        
        if (!sprite_exists(picture)) {
            picture = b_tileset_checkers;
            error_log("Missing tileset image; using default tileset instead: " + argument[0]);
        }
    }
    
    array_clear(autotiles, noone);
    
    flags = tileset_create_grid(picture, 0);
    at_flags = array_create(AUTOTILE_MAX);
    array_clear(at_flags, 0);
    
    master = tileset_create_master(id);
    
    instance_deactivate_object(id);
    return id;
}