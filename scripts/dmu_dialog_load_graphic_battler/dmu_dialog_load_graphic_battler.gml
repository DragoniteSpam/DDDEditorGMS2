/// @param UIThing

var fn = get_open_filename("Image files (*.png)|*.png", "");

if (file_exists(fn)) {
    graphics_add_battler(fn);
}