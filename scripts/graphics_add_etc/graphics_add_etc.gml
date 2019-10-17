/// @param filename
/// @param [name]

var filename = argument[0];
var name = (argument_count > 1) ? argument[1] : filename_name(filename);
var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));

// @todo validate internal name

var data = instance_create_depth(0, 0, 0, DataImage);
data.name = name;
data.picture = sprite_add(filename, 0, false, false, 0, 0);

internal_name_set(data, internal_name);

ds_list_add(Stuff.all_graphic_etc, data);

return data;