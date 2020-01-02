/// @param projname
/// @param filename
/// @param buffer

var name = argument0;
var filename = argument1;
var buffer = argument2;

var auto_folder = PATH_PROJECTS + name + "\\";
if (!directory_exists(auto_folder)) {
    directory_create(auto_folder);
}

buffer_save_ext(buffer, auto_folder + filename, 0, buffer_get_size(buffer));