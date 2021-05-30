event_inherited();

type = DataTypes.INT;
type_guid = NULL;

value = 0;
value_real = 0;
value_string = "";
value_guid = NULL;

CreateJSONConst = function() {
    var json = self.CreateJSONBase();
    json.type = self.type;
    json.type_guid = self.type_guid;
    json.value = self.value; 
    return json;
};

CreateJSON = function() {
    return self.CreateJSONConst();
};