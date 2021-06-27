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
            self.properties[i] = new DataProperty(self.properties[i]);
        }
        
        for (var i = 0; i < array_length(self.instances); i++) {
            self.instances[i] = new DataProperty(self.instances[i]);
        }
    }
}

function DataProperty(name, parent) : SData(name) constructor {
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
        // this is literally all the data we actually need in the game
        buffer_write(buffer, buffer_u32, self.type);
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
}

function DataInstance(name) : SData(name) constructor {
    parent = NULL;
    values = [];
    
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
}