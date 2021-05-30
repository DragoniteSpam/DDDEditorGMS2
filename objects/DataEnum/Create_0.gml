event_inherited();

name = "DataEnum" + string(ds_list_size(Stuff.all_data) - 1);
summary = "";

properties = ds_list_create();

type = DataTypes.ENUM;

CreateJSONEnum = function() {
    var json = self.CreateJSONBase();
    json.type = self.type;
    return json;
};

CreateJSON = function() {
    return self.CreateJSONEnum();
};