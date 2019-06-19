/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    if (Stuff.setting_alphabetize_lists) {
        var listofthings = ds_list_sort_name_sucks(Stuff.all_bgm);
    } else {
        var listofthings = Stuff.all_bgm;
    }
    
    argument0.root.el_name.value = listofthings[| selection].name;
    argument0.root.el_name_internal.value = listofthings[| selection].internal_name;
    argument0.root.el_loop_start.value = string(listofthings[| selection].loop_start);
    argument0.root.el_loop_end.value = string(listofthings[| selection].loop_end);
    
    if (Stuff.fmod_sound != noone) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    }
    
    if (Stuff.setting_alphabetize_lists) {
        ds_list_destroy(listofthings);
    }
}
