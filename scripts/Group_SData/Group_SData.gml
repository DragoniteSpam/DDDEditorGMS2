function SData(name) constructor {
    self.name = name;
    if (self.name == undefined) name = "data"
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
}