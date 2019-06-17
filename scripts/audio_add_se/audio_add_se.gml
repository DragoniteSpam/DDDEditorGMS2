/// @param filename
/// @param [name]

var filename = argument[0];
var name = (argument_count > 1) ? argument[1] : filename_name(filename);
name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));

file_copy(filename, PATH_AUDIO + name + filename_ext(filename));

var data = [name, guid_generate(), filename, FMODGMS_Snd_LoadStream(filename)];
guid_set(data, data[@ AudioProperties.GUID]);
ds_list_add(Stuff.all_se, data);