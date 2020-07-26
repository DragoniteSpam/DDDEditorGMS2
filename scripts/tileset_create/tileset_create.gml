/// @param file/name
/// @param [autotiles]
/// @param [sprite-index]
/// @param [create-master?]

var file_hash = "";
if (file_exists(argument[0])) {
    file_hash = md5_file(argument[0]);
    for (var i = 0; i < ds_list_size(Stuff.all_graphic_tilesets); i++) {
        var ts = Stuff.all_graphic_tilesets[| i];
        if (ts.hash == file_hash) {
            return ts;
        }
    }
}

// don't instantiate these outside of this script
with (instance_create_depth(0, 0, 0, DataTileset)) {
    name = filename_change_ext(filename_name(argument[0]), "");
    // this needs to be the file path
    picture_name = argument[0];
    
    internal_name_generate(id, PREFIX_GRAPHIC_TILESET + string_lettersdigits(filename_change_ext(filename_name(picture_name), "")));
    
    autotiles = (argument_count > 1 && argument[1] != undefined) ? argument[1] : autotiles;
    picture = (argument_count > 2 && argument[2] != undefined) ? argument[2] : sprite_add(picture_name, 0, false, false, 0, 0);
    var create_master = (argument_count > 3 && argument[3] != undefined) ? argument[3] : true;
    hash = file_hash;
    
    if (!sprite_exists(picture)) {
        picture = sprite_duplicate(b_tileset_checkers);
        wtf("Missing tileset image; using default tileset instead: " + picture_name);
    }
    
    array_clear(autotiles, noone);
    
    flags = tileset_create_grid(picture, 0);
    at_flags = array_create(AUTOTILE_MAX);
    array_clear(at_flags, 0);
    
    master = create_master ? tileset_create_master(id) : b_tileset_textureless;
    
    ds_list_add(Stuff.all_graphic_tilesets, id);
    
    instance_deactivate_object(id);
    
    return id;
}