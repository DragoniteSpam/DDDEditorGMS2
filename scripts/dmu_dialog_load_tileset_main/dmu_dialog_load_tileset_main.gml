/// @param UIButton

var button = argument0;

var fn = get_open_filename_image();

if (file_exists(fn)) {
    var ts = get_active_tileset();
    // @todo gml update, try-catch?
    sprite_delete(ts.picture);
    var picture = sprite_add(fn, 0, false, false, 0, 0);
    
    var osw = sprite_get_width(picture);
    var osh = sprite_get_height(picture);
    if (osw <= TILESET_MAX_SIZE && osh <= TILESET_MAX_SIZE) {
        ts.picture = picture;
    } else {
        var sw = min(TILESET_MAX_SIZE, sprite_get_width(picture));
        var sh = min(TILESET_MAX_SIZE, sprite_get_height(picture));
        var surface = surface_create(sw, sh);
        surface_set_target(surface);
        draw_clear_alpha(c_black, 0);
        draw_sprite(picture, 0, 0, 0);
        surface_reset_target();
        ts.picture = sprite_create_from_surface(surface, 0, 0, sw, sh, false, false, 0, 0);
        sprite_delete(picture);
        surface_free(surface);
        
        dialog_create_notice(button.root, "This tileset is " + string(osw) + " x " + string(osh) + ". It will be cropped to " + string(sw) + " x " + string(sh) + ".");
    }
    
    sprite_delete(ts.master);
    ts.master = tileset_create_master(ts);
}