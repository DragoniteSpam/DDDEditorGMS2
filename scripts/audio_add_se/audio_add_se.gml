/// @param filename
/// @param [name]
function audio_add_se() {

	var filename = argument[0];
	var name = (argument_count > 1) ? argument[1] : filename_name(filename);
	var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));

	var data = instance_create_depth(0, 0, 0, DataAudio);
	data.name = name;
	data.fmod = FMODGMS_Snd_LoadStream(filename);
	data.fmod_type = FMODGMS_Snd_Get_Type(data.fmod);

	internal_name_generate(data, PREFIX_AUDIO_SE + internal_name);

	data.temp_name = PATH_AUDIO + string(data.GUID) + filename_ext(filename);
	file_copy(filename, data.temp_name);

	ds_list_add(Stuff.all_se, data);

	return data;


}
