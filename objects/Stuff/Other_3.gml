FMODGMS_Chan_StopChannel(fmod_channel);
// sound should be stopped in audio_remove_*
FMODGMS_Chan_RemoveChannel(fmod_channel);
FMODGMS_Sys_Close();