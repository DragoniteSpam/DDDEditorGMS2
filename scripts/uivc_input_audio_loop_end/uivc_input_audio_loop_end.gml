/// @param UIInput

var input = argument0;

var selection = ui_list_selection(input.root.el_list);
if (selection + 1) {
    if (!ds_list_empty(Stuff.all_bgm)) {
        var bgm = Stuff.all_bgm[| selection];
        bgm.loop_end = real(input.value);
        var position = FMODGMS_Chan_Get_Position(bgm.fmod);
        FMODGMS_Snd_Set_LoopPoints(bgm.fmod, bgm.loop_start * bgm.fmod_rate, bgm.loop_end * bgm.fmod_rate);
        // setting a loop point while the sound is playing makes things weird so we just stop it instead
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
        FMODGMS_Chan_Set_Position(Stuff.fmod_channel, position);
    }
}