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
    
    self.Export = function(buffer) {
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
            array_push(self.instances[i].values, [0]);
        }
    };
    
    static RemoveProperty = function(property) {
        var index = array_get_index(self.properties, property);
        if (index == -1) return;
        array_delete(self.properties, index, 1);
        for (var i = 0, n = array_length(self.instances); i < n; i++) {
            array_delete(self.instances[i].values, index, 1);
        }
    };
    
    static MovePropertyUp = function(property) {
        var index = array_get_index(self.properties, property);
        if (index < 1) return;
        
        var t = self.properties[index];
        self.properties[index] = self.properties[index - 1];
        self.properties[index - 1] = t;
        for (var i = 0, n = array_length(self.instances); i < n; i++) {
            var instance = self.instances[i];
            t = instance.values[index];
            instance.values[index] = instance.values[index - 1];
            instance.values[index - 1] = t;
        }
    };
    
    static MovePropertyDown = function(property) {
        var index = array_get_index(self.properties, property);
        if (index == -1 || index == array_length(self.properties) - 1) return;
        
        var t = self.properties[index];
        self.properties[index] = self.properties[index + 1];
        self.properties[index + 1] = t;
        for (var i = 0, n = array_length(self.instances); i < n; i++) {
            var instance = self.instances[i];
            t = instance.values[index];
            instance.values[index] = instance.values[index + 1];
            instance.values[index + 1] = t;
        }
    };
    
    static AddInstance = function(instance, position = array_length(self.instances)) {
        if (!instance) {
            instance = new DataInstance(self.name + string(array_length(self.instances)));
            instance.parent = self.GUID;
            
            for (var i = 0; i < array_length(self.properties); i++) {
                var property = self.properties[i];
                switch (property.type) {
                    case DataTypes.INT:
                    case DataTypes.COLOR:
                        array_push(instance.values, [property.default_int]);
                        break;
                    case DataTypes.FLOAT:
                        array_push(instance.values, [property.default_real]);
                        break;
                    case DataTypes.ASSET_FLAG:
                        array_push(instance.values, [0]);
                        break;
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                    case DataTypes.MESH:
                    case DataTypes.MESH_AUTOTILE:
                    case DataTypes.IMG_TEXTURE:
                    case DataTypes.IMG_BATTLER:
                    case DataTypes.IMG_OVERWORLD:
                    case DataTypes.IMG_PARTICLE:
                    case DataTypes.IMG_UI:
                    case DataTypes.IMG_ETC:
                    case DataTypes.IMG_SKYBOX:
                    case DataTypes.IMG_TILE_ANIMATION:
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
                    case DataTypes.ANIMATION:
                    case DataTypes.MAP:
                    case DataTypes.EVENT:
                        array_push(instance.values, [NULL]);
                        break;
                    case DataTypes.STRING:
                        array_push(instance.values, [property.default_string]);
                        break;
                    case DataTypes.BOOL:
                        array_push(instance.values, [!!property.default_int]);
                        break;
                    case DataTypes.CODE:
                        array_push(instance.values, [property.default_code]);
                        break;
                    case DataTypes.TILE:
                    case DataTypes.ENTITY:
                        instance.Destroy();
                        not_yet_implemented();
                        break;
                }
            }
        }
        
        array_insert(self.instances, position, instance);
    };
    
    static RemoveInstance = function(inst) {
        var index = array_get_index(self.instances, inst);
        array_delete(self.instances, index, 1);
    };
    
    static Destroy = function() {
        array_delete(Game.data, array_get_index(Game.data, self), 1);
        self.DestroyBase();
    };
    
    if (is_struct(source)) {
        self.properties = source.properties;
        self.instances = source.instances;
        self.type = source.type;
        
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
    
    self.Export = function(buffer) {
        // DON'T call the inherited ExportBase()!
        buffer_write(buffer, buffer_string, self.name);
        buffer_write(buffer, buffer_datatype, self.GUID);
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
    
    enum DataInstanceFlags {
        NO_LOCALIZE         = 0x010000,
        DEFAULT_VALUE       = 0x020000,
        SEPARATOR_VALUE     = 0x040000,
    }
    
    self.Export = function(buffer) {
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
    
    static Clone = function() {
        var clone = self.CloneBase(DataInstance);
        clone.parent = self.parent;
        clone.values = json_parse(json_stringify(self.values));
        return clone;
    };
    
    if (is_struct(source)) {
        self.parent = source.parent;
        self.values = source.values;
    }
}