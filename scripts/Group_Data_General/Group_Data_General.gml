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

function DataValue(name) constructor {
    self.name = name;
    
    self.type = DataTypes.INT;
    self.value_real = 0;
    self.value_int = 0;
    self.value_string = "";
    self.value_bool = false;         // we also use this for u64s
    self.value_color = c_black;
    self.value_code = "";
    self.value_type_guid = NULL;
    self.value_data = 0;
}