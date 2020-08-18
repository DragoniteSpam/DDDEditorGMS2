/// @param filename
/// @param [name]
function audio_add_bgm() {

	var filename = argument[0];
	var name = (argument_count > 1) ? argument[1] : filename_name(filename);
	var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));

	var data = instance_create_depth(0, 0, 0, DataAudio);
	data.name = name;
	data.fmod = FMODGMS_Snd_LoadStream(filename);
	data.fmod_type = FMODGMS_Snd_Get_Type(data.fmod);
	FMODGMS_Snd_Set_LoopMode(data.fmod, FMODGMS_LOOPMODE_NORMAL, -1);
	data.loop_start = 0;
	data.loop_end = FMODGMS_Snd_Get_Length(data.fmod);
	FMODGMS_Snd_Set_LoopPoints(data.fmod, 0, data.loop_end);

	internal_name_generate(data, PREFIX_AUDIO_BGM + internal_name);

	data.temp_name = PATH_AUDIO + string(data.GUID) + filename_ext(filename);
	file_copy(filename, data.temp_name);

	ds_list_add(Stuff.all_bgm, data);

	return data;


}
