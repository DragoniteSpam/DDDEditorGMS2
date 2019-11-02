/// @param UIButton

var button = argument0;

var fn = get_save_filename_image();

if (fn != "") {
    terrain_export_heightmap(fn);
}