function SData(source) constructor {
    if (source == undefined) source = "data";
    
    self.flags = 0;
    self.summary = "";
    self.GUID = NULL;
    self.internal_name = "";
    guid_set(self, guid_generate());
    internal_name_set(self, "SData" + string_lettersdigits(self.GUID));
    
    static LoadJSONBase = function(json) {
        self.name = json.name;
        internal_name_set(self, json.internal_name);
        self.flags = json.flags;
        self.summary = json.summary;
        guid_set(self, json.GUID);
    };
    
    static LoadJSON = function(json) {
        self.LoadJSONBase(json);
    };
    
    static DestroyBase = function() {
        if (Stuff.is_quitting) exit;
        guid_remove(self.GUID);
        internal_name_remove(self.internal_name);
    };
    
    static Destroy = function() {
        self.DestroyBase();
    };
    
    static CreateJSONBase = function() {
        return {
            name: name,
            internal_name: internal_name,
            flags: flags,
            summary: summary,
            GUID: GUID,
        };
    };
    
    static CreateJSON = function() {
        return self.CreateJSONBase();
    };
    
    if (is_string(source)) {
        self.name = source;
    } else {
        self.LoadJSON(source);
    }
}