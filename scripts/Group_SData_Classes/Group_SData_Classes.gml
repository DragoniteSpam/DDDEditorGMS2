function DataClass(source) : SData(source) constructor {
    self.properties = [];
    // all of the instances of the data type; nested lists
    self.instances = [];
    
    self.type = DataTypes.DATA;
    
    enum DataDataFlags {
        NO_LOCALIZE         = 0x010000,
        NO_LOCALIZE_NAME    = 0x020000,
        NO_LOCALIZE_SUMMARY = 0x040000,
    }
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.type);
        buffer_write(buffer, buffer_u32, array_length(self.properties));
        for (var i = 0; i < array_length(self.properties); i++) {
            self.properties[i].Export(buffer);
        }
        buffer_write(buffer, buffer_u32, array_length(self.instances));
        for (var i = 0; i < array_length(self.instances); i++) {
            self.instances[i].Export(buffer);
        }
    };
    
    static AddProperty = function(property) {
        array_push(self.properties, property);
        for (var i = 0, n = array_length(self.instances); i < n; i++) {
            array_push(self.instances[i].values, 0);
        }
    };
    
    static RemoveProperty = function(property) {
        var index = array_search(self.properties, property);
        array_delete(self.properties, index, 1);
        for (var i = 0, n = array_length(self.instances); i < n; i++) {
            array_delete(self.instances[i].values, index, 1);
        }
    };
    
    static AddInstance = function(inst, position) {
        if (position == undefined) position = array_length(self.instances);
        self.instances[position] = inst;
    };
    
    static RemoveInstance = function(inst) {
        var index = array_search(self.instances, inst);
        array_delete(self.instances, index, 1);
    };
    
    static Destroy = function() {
        array_delete(Game.data, array_search(Game.data, self), 1);
        self.DestroyBase();
    };
    
    if (is_struct(source)) {
        self.properties = source.properties;
        self.instances = source.instances;
        
        for (var i = 0; i < array_length(self.properties); i++) {
            self.properties[i] = new DataProperty(self.properties[i], self);
        }
        
        for (var i = 0; i < array_length(self.instances); i++) {
            self.instances[i] = new DataInstance(self.instances[i]);
        }
    }
}

function DataProperty(source, parent) : SData(source) constructor {
    self.parent = parent.GUID;
    
    self.type = DataTypes.INT;
    self.range_min = 0;                        // int, float
    self.range_max = 10;                       // int, float
    self.number_scale = NumberScales.LINEAR;   // int, float
    self.char_limit = 20;                      // string
    self.type_guid = NULL;                     // Data, enum
    self.max_size = 1;
    self.size_can_be_zero = false;
    self.default_real = 0;
    self.default_int = 0;
    self.default_string = "";
    self.default_code = "";
    
    static Export = function(buffer) {
        // DON'T call the inherited ExportBase()!
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_u32, self.type);
        buffer_write(buffer, buffer_bool, (self.max_size == 1) && !self.size_can_be_zero);
    }
    
    static Destroy = function() {
        guid_get(self.parent).RemoveProperty(self);
        self.DestroyBase();
    };
    
    enum NumberScales {
        LINEAR,
        QUADRATIC,
        EXPONENTIAL,
    }
    
    enum DataPropertyFlags {
        NO_LOCALIZE         = 0x010000,
    }
    
    if (is_struct(source)) {
        self.type = source.type;
        self.range_min = source.range_min;
        self.range_max = source.range_max;
        self.number_scale = source.number_scale;
        self.char_limit = source.char_limit;
        self.type_guid = source.type_guid;
        self.max_size = source.max_size;
        self.size_can_be_zero = source.size_can_be_zero;
        self.default_real = source.default_real;
        self.default_int = source.default_int;
        self.default_string = source.default_string;
        self.default_code = source.default_code;
    }
}

function DataInstance(source) : SData(source) constructor {
    self.parent = NULL;
    self.values = [];
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        var class = guid_get(self.parent);
        for (var i = 0; i < array_length(class.properties); i++) {
            var type = Stuff.data_type_meta[class.properties[i].type].buffer_type;
            buffer_write(buffer, buffer_u16, array_length(self.values[i]));
            for (var j = 0; j < array_length(self.values[i]); j++) {
                buffer_write(buffer, type, self.values[i][j]);
            }
        }
    };
    
    if (is_struct(source)) {
        self.parent = source.parent;
        self.values = source.values;
    }
}