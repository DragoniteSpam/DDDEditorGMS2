/// @param UIThing

var fn = get_open_filename("Image files (*.png;*.bmp)|*.png;*.bmp", "");

if (file_exists(fn)) {
    graphics_add_ui(fn);
}