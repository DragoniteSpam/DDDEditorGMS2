if (Stuff.is_quitting) exit;

event_inherited();

if (fmod) {
    FMODGMS_Snd_Unload(fmod);
}