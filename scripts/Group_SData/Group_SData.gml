function SData(source) constructor {
    if (source == undefined) source = "data";
    
    self.flags = 0;
    self.summary = "";
    self.GUID = NULL;
    self.internal_name = "";
    guid_set(self, guid_generate());
    internal_name_set(self, "SData" + string_lettersdigits(self.GUID));
    
    static DestroyBase = function() {
        if (Stuff.is_quitting) exit;
        guid_remove(self.GUID);
        internal_name_remove(self.internal_name);
    };
    
    static Destroy = function() {
        self.DestroyBase();
    };
    
    static ExportBase = function(buffer) {
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_string, self.internal_name);
        buffer_write(buffer, buffer_datatype, self.summary);
        buffer_write(buffer, buffer_flag, self.flags);
    };
    
    static Export = function(buffer) {
        self.ExportBase();
    };
    
    static CreateJSONBase = function() {
        return {
            name: self.name,
            internal_name: self.internal_name,
            flags: self.flags,
            summary: self.summary,
            GUID: self.GUID,
        };
    };
    
    static CreateJSON = function() {
        return self.CreateJSONBase();
    };
    
    if (is_string(source)) {
        self.name = source;
    } else {
        self.name = source.name;
        internal_name_set(self, source.internal_name);
        self.flags = source.flags;
        self.summary = source.summary;
        guid_set(self, source.GUID);
    }
}