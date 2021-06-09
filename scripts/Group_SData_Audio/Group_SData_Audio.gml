function DataAudio(name) : SData(name) constructor {
    self.fmod = noone;
    self.fmod_type = 0;          // FMODGMS_SOUND_TYPE_*
    self.fmod_rate = 44100;
    self.temp_name = "";
    
    self.loop_start = 0;
    self.loop_end = 0;
    
    static GetBuffer = function() {
        if (file_exists(self.temp_name)) return buffer_load(self.temp_name);
        return -1;
    };
    
    static SaveAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        var temp_name = string_replace_all(filename_name(self.temp_name), ":", "_");
        var fbuffer = self.GetBuffer();
        if (buffer_exists(fbuffer)) buffer_save(fbuffer, directory + temp_name);
        buffer_delete(fbuffer);
    };
    
    static CreateJSONAudio = function() {
        var json = self.CreateJSONBase();
        json.fmod_type = self.fmod_type;
        json.fmod_rate = self.fmod_rate;
        json.temp_name = self.temp_name;
        json.loop_start = self.loop_start;
        json.loop_end = self.loop_end;
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONAudio();
    };
    
    static Destroy = function() {
        if (self.fmod) FMODGMS_Snd_Unload(self.fmod);
    }
}