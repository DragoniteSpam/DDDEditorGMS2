function tileset_create(filename, sprite) {
    var file_hash = "";
    if (file_exists(filename)) {
        file_hash = md5_file(filename);
        for (var i = 0; i < ds_list_size(Stuff.all_graphic_tilesets); i++) {
            var ts = Stuff.all_graphic_tilesets[| i];
            if (ts.hash == file_hash) {
                return ts;
            }
        }
    }
    
    // don't instantiate these outside of this script
    with (instance_create_depth(0, 0, 0, DataTileset)) {
        name = filename_change_ext(filename_name(filename), "");
        // this needs to be the file path
        source_filename = filename;
        
        internal_name_generate(id, PREFIX_GRAPHIC_TILESET + string_lettersdigits(filename_change_ext(filename_name(source_filename), "")));
        
        picture = (sprite != undefined) ? sprite : sprite_add(source_filename, 0, false, false, 0, 0);
        hash = file_hash;
        
        if (!sprite_exists(picture)) {
            picture = sprite_duplicate(b_tileset_magenta);
            wtf("Missing tileset image; using default instead: " + source_filename);
        }
        
        width = sprite_get_width(picture);
        height = sprite_get_height(picture);
        hframes = width div Stuff.tile_size;
        vframes = height div Stuff.tile_size;
        flags = array_create_2d(hframes, vframes, 0);
        
        ds_list_add(Stuff.all_graphic_tilesets, id);
        instance_deactivate_object(id);
        
        return id;
    }
}