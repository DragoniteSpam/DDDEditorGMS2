var path = get_open_filename_ext("Image files (*.png)|*.png", "", Stuff.setting_location_image, "Select an image");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_image = dir;
    setting_save_string("location", "image", dir);
}

return path;