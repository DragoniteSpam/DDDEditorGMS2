/// @description this is for all types of audio, currently
event_inherited();

fmod = noone;
fmod_type = 0;          // FMODGMS_SOUND_TYPE_*
fmod_rate = 44100;
temp_name = "";

loop_start = 0;
loop_end = 0;

GetBuffer = function() {
    if (file_exists(self.temp_name)) return buffer_load(self.temp_name);
    return -1;
};

SaveAsset = function(directory) {
    directory += "/";
    var guid = string_replace(self.GUID, ":", "_");
    var temp_name = string_replace_all(filename_name(self.temp_name), ":", "_");
    var fbuffer = self.GetBuffer();
    if (buffer_exists(fbuffer)) buffer_save(fbuffer, directory + temp_name);
    buffer_delete(fbuffer);
};

CreateJSONAudio = function() {
    var json = self.CreateJSONBase();
    json.fmod_type = self.fmod_type;
    json.fmod_rate = self.fmod_rate;
    json.temp_name = self.temp_name;
    json.loop_start = self.loop_start;
    json.loop_end = self.loop_end;
    return json;
};

CreateJSON = function() {
    return self.CreateJSONAudio();
};