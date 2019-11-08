/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

var path = get_save_filename_ext("Image files (*.png)|*.png", name, Stuff.setting_location_image, "Select an image");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_image = dir;
    setting_set("Location", "image", dir);
}

return path;