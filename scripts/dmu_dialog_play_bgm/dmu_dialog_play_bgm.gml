/// @param UIButton
function dmu_dialog_play_bgm(argument0) {

	var button = argument0;

	var selection = ui_list_selection(button.root.el_list);

	if (selection + 1) {
	    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    
	    var what = Stuff.all_bgm[| selection];
	    Stuff.fmod_sound = what.fmod;
	    FMODGMS_Snd_PlaySound(Stuff.fmod_sound, Stuff.fmod_channel);
	    FMODGMS_Chan_Set_Frequency(Stuff.fmod_channel, what.fmod_rate);
	}


}
