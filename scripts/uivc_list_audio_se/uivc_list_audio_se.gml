/// @param UIList
function uivc_list_audio_se(argument0) {

	var list = argument0;
	var selection = ui_list_selection(list);

	if (selection >= 0) {
	    var what = Stuff.all_se[| selection];
	    ui_input_set_value(list.root.el_name, what.name);
	    ui_input_set_value(list.root.el_name_internal, what.internal_name);
	    ui_input_set_value(list.root.el_sample_rate, string(what.fmod_rate));
    
	    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
	}


}
