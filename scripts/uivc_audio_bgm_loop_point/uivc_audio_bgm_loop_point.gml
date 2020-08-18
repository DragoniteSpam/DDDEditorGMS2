/// @param UIThing
function uivc_audio_bgm_loop_point(argument0) {

	FMODGMS_Chan_Set_Position(Stuff.fmod_channel, argument0.value * FMODGMS_Snd_Get_Length(Stuff.fmod_sound));


}
