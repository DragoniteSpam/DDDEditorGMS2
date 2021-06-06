event_inherited();

name = "DataEnum" + string(ds_list_size(Stuff.all_data) - 1);
summary = "";

properties = ds_list_create();

type = DataTypes.ENUM;

LoadJSONData = function(struct) {
    self.LoadJSONBase(struct);
    self.type = struct.type;
    for (var i = 0, n = array_length(struct.properties); i < n; i++) {
        var property = instance_create_depth(0, 0, 0, DataProperty);
        property.CreateJSON(struct.properties[i]);
        ds_list_add(self.properties, property);
    }
    for (var i = 0, n = array_length(struct.instances); i < n; i++) {
        var instance = instance_create_depth(0, 0, 0, DataInstantiated);
        instance.CreateJSON(struct.instances[i]);
        ds_list_add(self.instances, instance);
    }
};

LoadJSON = function(struct) {
    self.LoadJSONData(struct);
};

CreateJSONEnum = function() {
    var json = self.CreateJSONBase();
    json.type = self.type;
    var n = ds_list_size(self.properties);
    json.properties = array_create(n);
    for (var i = 0; i < n; i++) {
        json.properties[i] = self.properties[| i].CreateJSON();
    }
    // don't save the instances, because enums have none
    return json;
};

CreateJSON = function() {
    return self.CreateJSONEnum();
};