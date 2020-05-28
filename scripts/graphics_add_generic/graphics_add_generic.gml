/// @param filename
/// @param list
/// @param [name]
/// @param [allow-remove-back?]

var filename = argument[0];
var prefix = argument[1];
var list = argument[2];
var name = (argument_count > 3 && argument[3] != undefined) ? argument[3] : filename_name(filename);
var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
var remove_back = ((argument_count > 4 && argument[4] != undefined) ? argument[4] : true) && !keyboard_check(vk_control);

var data = instance_create_depth(0, 0, 0, DataImage);
data.name = name;
data.picture = sprite_add(filename, 0, remove_back, false, 0, 0);
data.width = sprite_get_width(data.picture);
data.height = sprite_get_height(data.picture);

internal_name_generate(data, prefix + internal_name);

ds_list_add(list, data);

return data;