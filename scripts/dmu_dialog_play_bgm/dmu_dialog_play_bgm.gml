/// @param UIThing

var selection = ui_list_selection(argument0.root.el_list);

if (selection != noone) {
    // this is really ugly but writing a better way to do alphabetized/non-alphabetized lists
    // will take a lot of time
    var list = ds_list_create();
    if (Stuff.setting_alphabetize_lists) {
        var priority = ds_priority_create();
        for (var i = 0; i < ds_list_size(Stuff.all_bgm); i++) {
            var data = Stuff.all_bgm[| i];
            ds_priority_add(priority, data, data[@ AudioProperties.NAME]);
        }
        while (!ds_priority_empty(priority)) {
            ds_list_add(list, ds_priority_delete_min(priority));
        }
        ds_priority_destroy(priority);
    } else {
        for (var i = 0; i < ds_list_size(Stuff.all_bgm); i++) {
            ds_list_add(list, Stuff.all_bgm[| i]);
        }
    }
    
    var data = list[| selection];
    
    if (Stuff.fmod_sound != noone) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    }
    
    Stuff.fmod_sound = data[@ AudioProperties.FMOD];
    FMODGMS_Snd_PlaySound(Stuff.fmod_sound, Stuff.fmod_channel);
    
    ds_list_destroy(list);
}