function SData(source = "data") constructor {
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
    
    self.ExportBase = function(buffer) {
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_string, self.internal_name);
        buffer_write(buffer, buffer_datatype, self.GUID);
        buffer_write(buffer, buffer_flag, self.flags);
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
    
    static CloneBase = function(constructor_function) {
        var clone = new constructor_function();
        clone.name = self.name;
        clone.flags = self.flags;
        clone.summary = self.summary;
        
        var iname_base = self.internal_name + "Copy";
        var iname_trial = iname_base;
        var n = 1;
        while (internal_name_get(iname_trial)) {
            iname_trial = iname_base + string(n++);
        }
        internal_name_set(clone, iname_trial);
        
        return clone;
    };
    
    if (is_string(source)) {
        self.name = source;
    } else if (is_struct(source)) {
        self.name = source.name;
        internal_name_set(self, source.internal_name);
        self.flags = source.flags;
        self.summary = source.summary;
        guid_set(self, source.GUID);
    }
}