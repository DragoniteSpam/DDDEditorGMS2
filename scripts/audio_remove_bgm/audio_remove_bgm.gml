/// @param guid

var guid = argument0;
var data = guid_get(guid);

guid_remove(guid);
FMODGMS_Snd_Unload(data.fmod);
ds_list_delete(Stuff.all_bgm, ds_list_find_index(Stuff.all_bgm, data));