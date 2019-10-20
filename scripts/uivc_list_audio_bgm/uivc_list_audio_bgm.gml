/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var what = Stuff.all_bgm[| selection];
    
    ui_input_set_value(list.root.el_name, what.name);
    ui_input_set_value(list.root.el_name_internal, what.internal_name);
    ui_input_set_value(list.root.el_loop_start, string(what.loop_start));
    ui_input_set_value(list.root.el_loop_end, string(what.loop_end));
    list.root.el_length.text = "Length: " + string(FMODGMS_Snd_Get_Length(what.fmod) / AUDIO_BASE_FREQUENCY) + " s";
    
    if (Stuff.fmod_sound) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    }
} else {
    list.root.el_length.text = "Length: N/A";
}