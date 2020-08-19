/// @param UIButton
function dmu_dialog_load_tileset_main(argument0) {

    var button = argument0;

    var fn = get_open_filename_image();

    if (file_exists(fn)) {
        var ts = get_active_tileset();
        // @gml update, try-catch?
        sprite_delete(ts.picture);
        ts.picture = sprite_add(fn, 0, false, false, 0, 0);
    }


}
