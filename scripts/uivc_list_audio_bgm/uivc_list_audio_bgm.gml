/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    // don't alphabetize these - causes trouble when renaming
    var what = Stuff.all_bgm[| selection];
    
    argument0.root.el_name.value = what.name;
    argument0.root.el_name_internal.value = what.internal_name;
    argument0.root.el_loop_start.value = string(what.loop_start);
    argument0.root.el_loop_end.value = string(what.loop_end);
    argument0.root.el_length.text = "Length: " + string(FMODGMS_Snd_Get_Length(what.fmod) / AUDIO_BASE_FREQUENCY) + " s";
    
    if (Stuff.fmod_sound) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    }
} else {
    argument0.root.el_length.text = "Length: N/A";
}