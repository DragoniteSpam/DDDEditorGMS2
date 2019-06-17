FMODGMS_Chan_StopChannel(fmod_channel);
if (fmod_sound != noone) {
    FMODGMS_Snd_Unload(fmod_sound);
}
FMODGMS_Chan_RemoveChannel(fmod_channel);
FMODGMS_Sys_Close();