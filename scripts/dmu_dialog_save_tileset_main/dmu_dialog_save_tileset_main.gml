/// @param UIThing
function dmu_dialog_save_tileset_main() {

    var fn = get_save_filename_image("output.png");

    if (fn != "") {
        sprite_save(get_active_tileset().picture, 0, fn);
    }


}
