/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection >= 0) {
    var what = Stuff.all_bgm[| selection];
    
    list.root.el_name.value = what.name;
    list.root.el_name_internal.value = what.internal_name;
    list.root.el_loop_start.value = string(what.loop_start);
    list.root.el_loop_end.value = string(what.loop_end);
    list.root.el_length.text = "Length: " + string(FMODGMS_Snd_Get_Length(what.fmod) / AUDIO_BASE_FREQUENCY) + " s";
    
    if (Stuff.fmod_sound) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    }
} else {
    list.root.el_length.text = "Length: N/A";
}