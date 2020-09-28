/// @param UIButton
function uivc_terrain_export_heightmap(argument0) {

    var button = argument0;

    var fn = get_save_filename_image();

    if (fn != "") {
        var dg = dialog_create_export_heightmap(button.root);
        dg.filename = fn;
    }


}
