function dialog_create_manager_audio_bgm(dialog) {
    var dg = dialog_create_manager_audio(dialog, "Background Music", PREFIX_AUDIO_BGM, Stuff.all_bgm);
    return dg;
}

function dialog_create_manager_audio_se(dialog) {
    var dg = dialog_create_manager_audio(dialog, "Sound Effects", PREFIX_AUDIO_SE, Stuff.all_se);
    dg.el_loop_start.interactive = false;
    dg.el_loop_end.interactive = false;
    return dg;
}