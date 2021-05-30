function SData(name) constructor {
    if (name == undefined) name = "data";
    self.name = name;
    self.flags = 0;
    self.summary = "";
    self.GUID = NULL;
    self.internal_name = "";
    guid_set(self, guid_generate());
    internal_name_set(self, "SData" + string_lettersdigits(self.GUID));
    
    self.Destroy = function() {
        if (Stuff.is_quitting) exit;
        guid_remove(self.GUID);
        internal_name_remove(self.internal_name);
    };
    
    self.CreateJSONBase = function() {
        return {
            name: name,
            internal_name: internal_name,
            flags: flags,
            summary: summary,
            guid: GUID,
        };
    };
    
    self.CreateJSON = function() {
        return self.CreateJSONBase();
    };
}