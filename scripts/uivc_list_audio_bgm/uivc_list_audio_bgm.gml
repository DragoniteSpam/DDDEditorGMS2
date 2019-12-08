/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var bgm = Stuff.all_bgm[| selection];
    
    ui_input_set_value(list.root.el_name, bgm.name);
    ui_input_set_value(list.root.el_name_internal, bgm.internal_name);
    ui_input_set_value(list.root.el_loop_start, string(bgm.loop_start / bgm.fmod_rate));
    ui_input_set_value(list.root.el_loop_end, string(bgm.loop_end / bgm.fmod_rate));
    ui_input_set_value(list.root.el_sample_rate, string(bgm.fmod_rate));
    list.root.el_length.text = "Length: " + string(FMODGMS_Snd_Get_Length(bgm.fmod) / bgm.fmod_rate) + " s";
    
    if (Stuff.fmod_sound) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    }
} else {
    list.root.el_length.text = "Length: N/A";
}