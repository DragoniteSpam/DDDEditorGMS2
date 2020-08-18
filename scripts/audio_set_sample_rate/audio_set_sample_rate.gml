/// @param DataAudio
/// @param rate
/// @param update-channel-rate
function audio_set_sample_rate(argument0, argument1) {

	var audio = argument0;
	var rate = argument1;

	audio.fmod_rate = rate;

	if (Stuff.fmod_sound == audio.fmod) {
	    FMODGMS_Chan_Set_Frequency(Stuff.fmod_channel, rate);
	}


}
