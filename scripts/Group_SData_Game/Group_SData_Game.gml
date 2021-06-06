function SDataGame(name) : SData(name) constructor {
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
    
    static RemoveProperty = function(index) {
        array_delete(self.properties, index, 1);
        for (var i = 0, n = array_length(self.instances); i < n; i++) {
            array_delete(self.instances[i].values, index, 1);
        }
    };
    
    static AddInstance = function(inst) {
        array_push(self.instances, inst);
    };
    
    static RemoveInstance = function(index) {
        array_delete(self.instances, index, 1);
    };
    
    static LoadJSONData = function(struct) {
        self.LoadJSONBase(struct);
        self.type = struct.type;
        for (var i = 0, n = array_length(struct.properties); i < n; i++) {
            var property = new DataProperty(struct.properties[i].name);
            property.CreateJSON(struct.properties[i]);
            ds_list_add(self.properties, property);
        }
        for (var i = 0, n = array_length(struct.instances); i < n; i++) {
            var instance = instance_create_depth(0, 0, 0, DataInstantiated);
            instance.CreateJSON(struct.instances[i]);
            ds_list_add(self.instances, instance);
        }
    };
    
    static LoadJSON = function(struct) {
        self.LoadJSONData(struct);
    };
    
    static CreateJSONData = function() {
        var json = self.CreateJSONBase();
        json.type = self.type;
        var n = ds_list_size(self.properties);
        json.properties = array_create(n);
        json.is_enum = false;
        for (var i = 0; i < n; i++) {
            json.properties[i] = self.properties[| i].CreateJSON();
        }
        n = ds_list_size(self.instances);
        json.instances = array_create(n);
        for (var i = 0; i < n; i++) {
            json.instances[i] = self.instances[| i].CreateJSON();
        }
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONData();
    };
}

function SDataProperty(name) : SData(name) constructor {
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
    
    static LoadJSONProperty = function(struct) {
        self.LoadJSONBase(struct);
        self.type = struct.type;
        self.range_min = struct.range_min;
        self.range_max = struct.range_max;
        self.number_scale = struct.number_scale;
        self.char_limit = struct.char_limit;
        self.type_guid = struct.type_guid;
        self.max_size = struct.max_size;
        self.size_can_be_zero = struct.size_can_be_zero;
        self.default_real = struct.default_real;
        self.default_int = struct.default_int;
        self.default_string = struct.default_string;
        self.default_code = struct.default_code;
    };
    
    static LoadJSON = function(struct) {
        self.LoadJSONProperty(struct);
    };
    
    static CreateJSONProperty = function() {
        var json = self.CreateJSONBase();
        json.type = self.type;
        json.range_min = self.range_min;
        json.range_max = self.range_max;
        json.number_scale = self.number_scale;
        json.char_limit = self.char_limit;
        json.type_guid = self.type_guid;
        json.max_size = self.max_size;
        json.size_can_be_zero = self.size_can_be_zero;
        json.default_real = self.default_real;
        json.default_int = self.default_int;
        json.default_string = self.default_string;
        json.default_code = self.default_code;
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONProperty();
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