/// @param UIButton
function uivc_terrain_save(argument0) {

    var button = argument0;

    var fn = get_save_filename_terrain();

    if (fn != "") {
        terrain_save(fn);
    }


}
