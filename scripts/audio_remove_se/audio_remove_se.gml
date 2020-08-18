/// @param guid
function audio_remove_se(argument0) {

	var data = guid_get(argument0);

	FMODGMS_Snd_Unload(data.fmod);
	ds_list_delete(Stuff.all_se, ds_list_find_index(Stuff.all_se, data));
	instance_activate_object(data);
	instance_destroy(data);


}
