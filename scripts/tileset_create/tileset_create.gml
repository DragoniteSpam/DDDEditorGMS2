/// @param file/name
/// @param autotile[]
/// @param [sprite-index]

// don't instantiate these outside of this script
with (instance_create_depth(0, 0, 0, DataTileset)) {
    picture_name = argument[0];
    
    internal_name_generate(id, PREFIX_GRAPHIC_TILESET + string_lettersdigits(picture_name));
    
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
    
    // these should be indices in Stuff.all_graphic_autotiles, not the
    // sprite asset itself!
    autotiles = argument[1];
    
    passage = tileset_create_grid(picture, TILE_PASSABLE);
    priority = tileset_create_grid(picture, 0);
    flags = tileset_create_grid(picture, 0);
    tags = tileset_create_grid(picture, TileTerrainTags.NONE);
    
    at_passage = array_create(AUTOTILE_MAX);
    at_priority = array_create(AUTOTILE_MAX);
    at_flags = array_create(AUTOTILE_MAX);
    at_tags = array_create(AUTOTILE_MAX);
    
    array_clear(at_passage, TILE_PASSABLE);
    array_clear(at_priority, 0);
    array_clear(at_flags, 0);
    array_clear(at_tags, TileTerrainTags.NONE);
    
    master = tileset_create_master(id);
    
    // don't do uivc_select_autotile_refresh here, the UI may not have been created yet

    instance_deactivate_object(id);
    return id;
}
