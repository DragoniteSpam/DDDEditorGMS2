/// @param UIThing

var selection = ui_list_selection(argument0.root.el_list);

if (selection != noone) {
    if (Stuff.setting_alphabetize_lists) {
        var list = ds_list_sort_name_sucks(Stuff.all_bgm);
    } else {
        var list = ds_list_create();
        ds_list_copy(list, Stuff.all_bgm);
    }
    
    if (Stuff.fmod_sound != noone) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
        Stuff.fmod_playing = false;
        Stuff.fmod_paused = false;
    }
    
    Stuff.fmod_sound = list[| selection].fmod;
    FMODGMS_Snd_PlaySound(Stuff.fmod_sound, Stuff.fmod_channel);
    Stuff.fmod_playing = true;
    
    ds_list_destroy(list);
}