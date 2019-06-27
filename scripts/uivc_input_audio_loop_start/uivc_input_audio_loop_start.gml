/// @param UIInput

if (script_execute(argument0.validation, argument0.value)) {
    var rv = real(argument0.value);
    if (is_clamped(rv, argument0.value_lower, argument0.value_upper)) {
        var selection = ui_list_selection(argument0.root.el_list);
        if (selection >= 0) {
            // no alphabetize
            if (!ds_list_empty(Stuff.all_bgm)) {
                var thing = Stuff.all_bgm[| selection];
                thing.loop_start = rv;
                var position = FMODGMS_Chan_Get_Position(thing.fmod);
                
                FMODGMS_Snd_Set_LoopPoints(thing.fmod, thing.loop_start * AUDIO_BASE_FREQUENCY, thing.loop_end * AUDIO_BASE_FREQUENCY);
                
                if (Stuff.fmod_playing) {
                    // setting a loop point while the sound is playing makes things weird so we just stop it instead
                    FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
                    FMODGMS_Chan_Set_Position(Stuff.fmod_channel, position);
                }
            }
        }
    }
}