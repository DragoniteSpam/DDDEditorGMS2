/// @param UIThing
function dmu_dialog_load_bgm() {

    var fn = get_open_filename_audio_fmod();

    if (file_exists(fn)) {
        audio_add_bgm(fn);
    }


}
