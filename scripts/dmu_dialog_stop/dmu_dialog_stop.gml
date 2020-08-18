/// @param UIButton
function dmu_dialog_stop(argument0) {

	var button = argument0;

	if (Stuff.fmod_sound) {
	    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
	}


}
