/// @param UIButton

var button = argument0;

var fn = get_save_filename_image();

if (fn != "") {
    var dg = dialog_create_export_heightmap(button.root);
    dg.filename = fn;
}