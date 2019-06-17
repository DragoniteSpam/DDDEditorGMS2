/// @param filename
/// @param [name]

var filename = argument[0];
var name = (argument_count > 1) ? argument[1] : filename_name(filename);

ds_list_add(Stuff.all_se, [name, guid_generate(), filename, noone, noone]);