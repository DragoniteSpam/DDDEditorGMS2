event_inherited();

// if more data is added here, and i don't think it will be, be
// sure to carry it over in both the save/load scripts and data_clone()

name = "DataType" + string(ds_list_size(Stuff.all_data) - 1);
summary = "";

properties = ds_list_create();

// all of the instances of the data type; nested lists
instances = ds_list_create();

enum DataDataFlags {
    NO_LOCALIZE         = 0x010000,
    NO_LOCALIZE_NAME    = 0x020000,
    NO_LOCALIZE_SUMMARY = 0x040000,
}

CreateJSONData = function() {
    var json = self.CreateJSONBase();
    var n = ds_list_size(self.properties);
    json.properties = array_create(n);
    for (var i = 0; i < n; i++) {
        json.properties[i] = self.properties[| i].CreateJSON();
    }
    return json;
};

CreateJSON = function() {
    return self.CreateJSONData();
};