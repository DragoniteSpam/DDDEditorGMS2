function SDataClass(name) : SData(name) constructor {
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
    
    static LoadJSONData = function(json) {
        self.LoadJSONBase(json);
        self.type = json.type;
        for (var i = 0, n = array_length(json.properties); i < n; i++) {
            var property = new DataProperty(json.properties[i].name);
            property.CreateJSON(json.properties[i]);
            array_push(self.properties, property);
        }
        for (var i = 0, n = array_length(json.instances); i < n; i++) {
            var instance = new SDataInstance("");
            instance.CreateJSON(json.instances[i]);
            array_push(self.instances, instance);
        }
    };
    
    static LoadJSON = function(json) {
        self.LoadJSONData(json);
    };
    
    static CreateJSONData = function() {
        var json = self.CreateJSONBase();
        json.type = self.type;
        var n = array_length(self.properties);
        json.properties = array_create(n);
        json.is_enum = false;
        for (var i = 0; i < n; i++) {
            json.properties[i] = self.properties[i].CreateJSON();
        }
        n = array_length(self.instances);
        json.instances = array_create(n);
        for (var i = 0; i < n; i++) {
            json.instances[i] = self.instances[i].CreateJSON();
        }
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONData();
    };
    
    static GoLive = function() {
        ds_list_add(Game.data, self);
    };
    
    static Retire = function() {
        ds_list_delete(Game.data, ds_list_find_index(Game.data, self));
    };
    
    static Destroy = function() {
        self.Retire();
        self.DestroyBase();
    };
}

function SDataProperty(name, parent) : SData(name) constructor {
    self.parent = parent;
    
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
    
    static LoadJSONProperty = function(json) {
        self.LoadJSONBase(json);
        self.type = json.type;
        self.range_min = json.range_min;
        self.range_max = json.range_max;
        self.number_scale = json.number_scale;
        self.char_limit = json.char_limit;
        self.type_guid = json.type_guid;
        self.max_size = json.max_size;
        self.size_can_be_zero = json.size_can_be_zero;
        self.default_real = json.default_real;
        self.default_int = json.default_int;
        self.default_string = json.default_string;
        self.default_code = json.default_code;
    };
    
    static LoadJSON = function(json) {
        self.LoadJSONProperty(json);
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
    
    static Destroy = function() {
        self.parent.RemoveProperty(self);
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