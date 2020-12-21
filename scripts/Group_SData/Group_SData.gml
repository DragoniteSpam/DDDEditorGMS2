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
}

function DataFile(name, compressed, critical) constructor {
    static names = { };
    
    static Rename = function(name) {
        if (name == self.name) return false;
        if (!ValidName(name)) return false;
        variable_struct_remove(names, self.name);
        names[$ name] = self;
        self.name = name;
        return true;
    };
    
    static ValidName = function(name) {
        if (!validate_string_internal_name(name)) return false;
        if (names[$ name]) return false;
        return true;
    };
    
    self.compressed = compressed;
    self.critical = critical;
    
    var iterator = 0;
    var name_test = name;
    while (!ValidName(name_test)) {
        name_test = name + "_" + string(iterator++);
    }
    self.name = name;
    names[$ name] = self;
}