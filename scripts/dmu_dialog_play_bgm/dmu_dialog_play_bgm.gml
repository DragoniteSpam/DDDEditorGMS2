/// @param UIThing

var thing = argument0;

var selection = ui_list_selection(thing.root.el_list);

if (selection) {
    if (Stuff.fmod_sound) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
        Stuff.fmod_playing = false;
        Stuff.fmod_paused = false;
    }
    
    Stuff.fmod_sound = Stuff.all_bgm[| selection].fmod;
    FMODGMS_Snd_PlaySound(Stuff.fmod_sound, Stuff.fmod_channel);
    Stuff.fmod_playing = true;
}