/// @param guid

var data = guid_get(argument0);

if (data[@ AudioProperties.FMOD] != noone) {
    FMODGMS_Snd_Unload(data[@ AudioProperties.FMOD]);
}

ds_list_delete(Stuff.all_se, ds_list_find_index(Stuff.all_se, data));