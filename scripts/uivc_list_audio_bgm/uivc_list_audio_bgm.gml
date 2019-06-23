/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    if (Stuff.setting_alphabetize_lists) {
        var listofthings = ds_list_sort_name_sucks(Stuff.all_bgm);
    } else {
        var listofthings = Stuff.all_bgm;
    }
    
    var what = listofthings[| selection];
    
    argument0.root.el_name.value = what.name;
    argument0.root.el_name_internal.value = what.internal_name;
    argument0.root.el_loop_start.value = string(what.loop_start);
    argument0.root.el_loop_end.value = string(what.loop_end);
    argument0.root.el_length.text = "Length: " + string(FMODGMS_Snd_Get_Length(what.fmod) / AUDIO_BASE_FREQUENCY) + " s";
    
    if (Stuff.fmod_sound != noone) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    }
    
    if (Stuff.setting_alphabetize_lists) {
        ds_list_destroy(listofthings);
    }
} else {
    argument0.root.el_length.text = "Length: N/A";
}