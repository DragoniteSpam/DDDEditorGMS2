/// @param guid

var data = guid_get(argument0);
guid_remove(argument0);

FMODGMS_Snd_Unload(data[@ AudioProperties.FMOD]);

// because you can't seek the index of an array in a list, apparently
for (var i = 0; i < ds_list_size(Stuff.all_se); i++) {
    var entry = Stuff.all_se[| i];
    if (entry[@ AudioProperties.GUID] == data[@ AudioProperties.GUID]) {
        ds_list_delete(Stuff.all_se, i);
        break;
    }
}