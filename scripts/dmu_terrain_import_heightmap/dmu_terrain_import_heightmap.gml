/// @param UIButton

var button = argument0;

var fn = get_open_filename_image();

if (fn != "") {
    terrain_import_heightmap(button, fn);
    script_execute(button.root.commit, button.root);
}