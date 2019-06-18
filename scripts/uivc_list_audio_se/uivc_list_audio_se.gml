/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    if (Stuff.setting_alphabetize_lists) {
        var listofthings = ds_list_sort_name_sucks(Stuff.all_se);
    } else {
        var listofthings = Stuff.all_se;
    }
    
    argument0.root.el_name.value = listofthings[| selection].name;
    argument0.root.el_name_internal.value = listofthings[| selection].internal_name;
    
    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    
    if (Stuff.setting_alphabetize_lists) {
        ds_list_destroy(listofthings);
    }
}