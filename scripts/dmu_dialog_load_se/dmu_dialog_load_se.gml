/// @param UIThing

var fn = get_open_filename("Audio files (*.wav)|*.wav", "");

if (file_exists(fn)) {
    audio_add_se(fn);
}