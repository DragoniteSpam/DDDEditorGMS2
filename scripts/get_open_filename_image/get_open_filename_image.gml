function get_open_filename_image() {
	var path = get_open_filename_ext("Image files (*.png, *.bmp)|*.png;*.bmp|PNG files|*.png|Bitmap files|*.bmp", "", Stuff.setting_location_image, "Select an image");

	// @gml update try-catch
	if (file_exists(path)) {
	    var dir = filename_dir(path);

	    if (string_length(dir) > 0) {
	        Stuff.setting_location_image = dir;
	        setting_set("Location", "image", dir);
	    }
	}

	return path;


}
