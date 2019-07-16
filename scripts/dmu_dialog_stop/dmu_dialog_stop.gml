/// @param UIThing

var catch = argument0;

if (Stuff.fmod_sound) {
    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    Stuff.fmod_playing = false;
}