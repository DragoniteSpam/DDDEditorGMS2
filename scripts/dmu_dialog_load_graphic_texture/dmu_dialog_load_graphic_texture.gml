/// @param UIButton

var button = argument0;

var fn = get_open_filename_image();

if (file_exists(fn)) {
    tileset_create(fn);
}