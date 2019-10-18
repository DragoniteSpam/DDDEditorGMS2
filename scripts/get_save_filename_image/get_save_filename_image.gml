/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

return get_save_filename("Image files (*.png)|*.png", name);