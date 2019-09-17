/// @param UIInput

var input = argument0;

var selection = ui_list_selection(input.root.el_list);
if (selection >= 0) {
    if (!ds_list_empty(Stuff.all_bgm)) {
        var thing = Stuff.all_bgm[| selection];
        thing.loop_end = real(input.value);
        var position = FMODGMS_Chan_Get_Position(thing.fmod);
        FMODGMS_Snd_Set_LoopPoints(thing.fmod, thing.loop_start * AUDIO_BASE_FREQUENCY, thing.loop_end * AUDIO_BASE_FREQUENCY);
        
        if (Stuff.fmod_playing) {
            // setting a loop point while the sound is playing makes things weird so we just stop it instead
            FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
            FMODGMS_Chan_Set_Position(Stuff.fmod_channel, position);
        }
    }
}