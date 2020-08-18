/// @param UIThing
function dmu_dialog_play_se(argument0) {

	var thing = argument0;
	var selection = ui_list_selection(thing.root.el_list);

	if (selection + 1) {
	    if (Stuff.fmod_sound) {
	        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
	    }
    
	    var what = Stuff.all_se[| selection];
	    Stuff.fmod_sound = what.fmod;
	    FMODGMS_Snd_PlaySound(Stuff.fmod_sound, Stuff.fmod_channel);
	    FMODGMS_Chan_Set_Frequency(Stuff.fmod_channel, what.fmod_rate);
	}


}
