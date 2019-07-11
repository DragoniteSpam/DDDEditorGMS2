/// @param UIThing

var fn = get_open_filename("images (*.bmp, *.png)|*.bmp;*.png", "");

if (file_exists(fn)) {
    var ts = get_active_tileset();
    // @todo gml update, try-catch?
    sprite_delete(ts.picture);
    ts.picture = sprite_add(fn, 0, false, false, 0, 0);
    
    sprite_delete(ts.master);
    ts.master = tileset_create_master(ts);
}