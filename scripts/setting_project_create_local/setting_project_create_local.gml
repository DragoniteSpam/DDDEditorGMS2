/// @param proj-name
/// @param buffer-asset
/// @param buffer-data

var name = argument0;
var buffer_asset = argument1;
var buffer_data = argument2;

var auto_folder = PATH_PROJECTS + name + "\\";
if (!directory_exists(auto_folder)) {
	directory_create(auto_folder);
}

if (buffer_asset != undefined) {
    buffer_save(buffer_asset, auto_folder + "auto" + EXPORT_EXTENSION_ASSETS);
}
if (buffer_data != undefined) {
    buffer_save(buffer_data, auto_folder + "auto" + EXPORT_EXTENSION_DATA);
}