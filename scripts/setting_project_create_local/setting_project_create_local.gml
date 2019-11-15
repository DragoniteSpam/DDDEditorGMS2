/// @param proj-name
/// @param buffer
/// @param extension

var name = argument0;
var buffer = argument1;
var extension = argument2;

var auto_folder = PATH_PROJECTS + name + "\\";
if (!directory_exists(auto_folder)) {
	directory_create(auto_folder);
}
buffer_save(buffer, auto_folder + "auto" + extension);