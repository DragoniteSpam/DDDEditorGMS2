/// @param UIThing

var fn = get_open_filename("Audio files (*.ogg, *.mid)|*.ogg;*.mid", "");

if (file_exists(fn)) {
    audio_add_bgm(fn);
}