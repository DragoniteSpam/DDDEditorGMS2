function DataAudio(source) : SData(source) constructor {
    self.source_filename = "";
    
    self.sample_rate = 44100;
    self.temp_name = "";
    
    self.loop_mode = false;
    self.loop_start = 0;
    self.loop_end = 0;
    
    if (is_struct(source)) {
        self.sample_rate = source.sample_rate;
        self.temp_name = source.temp_name;
        self.loop_start = source.loop_start;
        self.loop_end = source.loop_end;
        self.loop_mode = source.loop_mode;
    }
    
    self.SetLoop = function(loop_mode = self.loop_mode, start = 0, finish = 1) {
        wtf("to do - audio loop settings");
        self.loop_mode = loop_mode;
    };
    
    self.SetSampleRate = function(rate) {
        self.sample_rate = rate;
    };
    
    self.GetBuffer = function() {
        if (file_exists(self.temp_name)) return buffer_load(self.temp_name);
        return -1;
    };
    
    self.LoadAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        file_copy(directory + guid, self.temp_name);
    };
    
    self.SaveAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        var fbuffer = self.GetBuffer();
        if (buffer_exists(fbuffer)) buffer_save(fbuffer, directory + guid);
        buffer_delete(fbuffer);
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.sample_rate);
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
    
    self.CreateJSONAudio = function() {
        var json = self.CreateJSONBase();
        json.sample_rate = self.sample_rate;
        json.temp_name = self.temp_name;
        json.loop_start = self.loop_start;
        json.loop_end = self.loop_end;
        json.loop_mode = self.loop_mode;
        return json;
    };
    
    self.CreateJSON = function() {
        return self.CreateJSONAudio();
    };
}
    