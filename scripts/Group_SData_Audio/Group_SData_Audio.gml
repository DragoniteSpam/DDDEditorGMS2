function DataAudio(source) : SData(source) constructor {
    self.fmod = -1;
    self.fmod_type = 0;          // FMODGMS_SOUND_TYPE_*
    self.fmod_rate = 44100;
    self.temp_name = "";
    
    self.loop_mode = FMODGMS_LOOPMODE_NONE;
    self.loop_start = 0;
    self.loop_end = 0;
    
    if (is_struct(source)) {
        self.fmod_type = source.fmod_type;
        self.fmod_rate = source.fmod_rate;
        self.temp_name = source.temp_name;
        self.loop_start = source.loop_start;
        self.loop_end = source.loop_end;
        self.loop_mode = source.loop_mode;
    }
    
    static SetFMOD = function(filename) {
        self.fmod = FMODGMS_Snd_LoadStream(filename);
        self.fmod_type = FMODGMS_Snd_Get_Type(self.fmod);
    };
    
    static SetFMODLoop = function(loop_mode = self.loop_mode, start = 0, finish = FMODGMS_Snd_Get_Length(self.fmod)) {
        self.loop_mode = loop_mode;
        FMODGMS_Snd_Set_LoopMode(self.fmod, loop_mode, -1);
        FMODGMS_Snd_Set_LoopPoints(self.fmod, start, finish);
    };
    
    static SetSampleRate = function(rate) {
        self.fmod_rate = rate;
        if (Stuff.fmod_sound == self.fmod) {
            FMODGMS_Chan_Set_Frequency(Stuff.fmod_channel, rate);
        }
    };
    
    static GetBuffer = function() {
        if (file_exists(self.temp_name)) return buffer_load(self.temp_name);
        return -1;
    };
    
    static LoadAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        file_copy(directory + guid, self.temp_name);
        self.SetFMOD(PROJECT_PATH_ROOT + self.temp_name);
        self.SetFMODLoop();
    };
    
    static SaveAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        var fbuffer = self.GetBuffer();
        if (buffer_exists(fbuffer)) buffer_save(fbuffer, directory + guid);
        buffer_delete(fbuffer);
    };
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u8, self.fmod_type);
        buffer_write(buffer, buffer_u32, self.fmod_rate);
        buffer_write(buffer, buffer_u32, self.loop_start);
        buffer_write(buffer, buffer_u32, self.loop_end);
        buffer_write(buffer, buffer_u32, self.loop_mode);
        var fbuffer = self.GetBuffer();
        buffer_write(buffer, buffer_bool, buffer_exists(fbuffer));
        if (buffer_exists(fbuffer)) {
            buffer_write_buffer(buffer, fbuffer);
            buffer_delete(fbuffer);
        }
    };
    
    static CreateJSONAudio = function() {
        var json = self.CreateJSONBase();
        json.fmod_type = self.fmod_type;
        json.fmod_rate = self.fmod_rate;
        json.temp_name = self.temp_name;
        json.loop_start = self.loop_start;
        json.loop_end = self.loop_end;
        json.loop_mode = self.loop_mode;
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONAudio();
    };
    
    static Destroy = function() {
        if (self.fmod) FMODGMS_Snd_Unload(self.fmod);
    }
}
    