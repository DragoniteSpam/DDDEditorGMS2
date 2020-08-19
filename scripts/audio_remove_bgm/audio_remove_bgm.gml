/// @param guid
function audio_remove_bgm(argument0) {

    var data = guid_get(argument0);

    FMODGMS_Snd_Unload(data.fmod);
    ds_list_delete(Stuff.all_bgm, ds_list_find_index(Stuff.all_bgm, data));
    instance_activate_object(data);
    instance_destroy(data);


}
