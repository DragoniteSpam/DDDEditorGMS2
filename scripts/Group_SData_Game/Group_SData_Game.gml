function SDataGame(name) : SData(name) constructor {
    self.properties = [];
    // all of the instances of the data type; nested lists
    self.instances = [];
    
    enum DataDataFlags {
        NO_LOCALIZE         = 0x010000,
        NO_LOCALIZE_NAME    = 0x020000,
        NO_LOCALIZE_SUMMARY = 0x040000,
    }
    
    static LoadJSONData = function(struct) {
        self.LoadJSONBase(struct);
        self.type = struct.type;
        for (var i = 0, n = array_length(struct.properties); i < n; i++) {
            var property = instance_create_depth(0, 0, 0, struct.properties[i].type == DataTypes.ENUM ? DataEnum : DataProperty);
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