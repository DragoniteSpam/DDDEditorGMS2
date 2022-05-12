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

function DataValue(name, value = 0) constructor {
    self.name = name;
    self.type = DataTypes.INT;
    self.type_guid = NULL;
    self.value = value;
}