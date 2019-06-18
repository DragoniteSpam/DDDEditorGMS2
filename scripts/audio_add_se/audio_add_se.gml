/// @param filename
/// @param [name]

var filename = argument[0];
var name = (argument_count > 1) ? argument[1] : filename_name(filename);
var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));

file_copy(filename, PATH_AUDIO + internal_name + filename_ext(filename));

var data = instance_create_depth(0, 0, 0, DataAudio);
data.name = name;
data.copy_name = internal_name;
data.filename = filename;
data.fmod = FMODGMS_Snd_LoadStream(filename);
internal_name_set(data, internal_name);

ds_list_add(Stuff.all_se, data);

return data;