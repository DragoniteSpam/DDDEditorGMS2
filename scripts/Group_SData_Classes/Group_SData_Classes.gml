function SDataClass(source) : SData(source) constructor {
    self.properties = [];
    // all of the instances of the data type; nested lists
    self.instances = [];
    
    self.type = DataTypes.DATA;
    
    enum DataDataFlags {
        NO_LOCALIZE         = 0x010000,
        NO_LOCALIZE_NAME    = 0x020000,
        NO_LOCALIZE_SUMMARY = 0x040000,
    }
    
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
    
    static GoLive = function() {
        array_push(Game.data, self);
    };
    
    static Retire = function() {
        array_delete(Game.data, array_search(Game.data, self), 1);
    };
    
    static Destroy = function() {
        self.Retire();
        self.DestroyBase();
    };
    
    if (is_struct(source)) {
        self.properties = source.properties;
        self.instances = source.properties;
    }
}

function SDataProperty(name, parent) : SData(name) constructor {
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