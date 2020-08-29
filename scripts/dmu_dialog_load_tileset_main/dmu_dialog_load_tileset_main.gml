function dmu_dialog_load_tileset_main(button) {
    
    var fn = get_open_filename_image();
    try {
        var picture = sprite_add(fn, 0, false, false, 0, 0);
        var ts = get_active_tileset();
        sprite_delete(ts.picture);
        ts.picture = picture;
    } catch (e) {
        
    }
}