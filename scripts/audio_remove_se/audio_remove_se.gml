/// @param guid

var data = guid_get(argument0);
guid_remove(argument0);

FMODGMS_Snd_Unload(data.fmod);

ds_list_delete(Stuff.all_se, ds_list_find_index(Stuff.all_se, data));