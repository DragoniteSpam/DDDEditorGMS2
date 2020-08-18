function get_open_filename_audio_effect() {
	var path = get_open_filename_ext("Audio files (*.wav)|*.wav", "", Stuff.setting_location_audio, "Select an audio file");

	// @gml update try-catch
	if (file_exists(path)) {
	    var dir = filename_dir(path);

	    if (string_length(dir) > 0) {
	        Stuff.setting_location_audio = dir;
	        setting_set("Location", "audio", dir);
	    }
	}

	return path;


}
