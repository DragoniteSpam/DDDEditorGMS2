event_inherited();

name = "DataEnum" + string(ds_list_size(Stuff.all_data) - 1);
summary = "";

properties = ds_list_create();

type = DataTypes.ENUM;

CreateJSONEnum = function() {
    var json = self.CreateJSONBase();
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