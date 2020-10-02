function dmu_dialog_load_se(thing) {
    var fn = get_open_filename_audio_effect();
    if (file_exists(fn)) {
        audio_add_se(fn);
    }
}