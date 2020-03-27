/// @param UIButton

var button = argument0;

var fn = get_open_filename_image();

if (file_exists(fn)) {
    var ts = get_active_tileset();
    // @gml update, try-catch?
    
    var source = sprite_add(fn, 0, false, false, 0, 0);
    
    sprite_delete(ts.picture);
    sprite_delete(ts.master);
    ts.picture = sprite_crop(source, 0, TILESET_MAX_SIZE, TILESET_MAX_SIZE);
    ts.master = tileset_create_master(ts);
    sprite_delete(source);
}