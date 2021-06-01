event_inherited();

// if more data is added here, and i don't think it will be, be
// sure to carry it over in both the save/load scripts and data_clone()

name = "Property";
type = DataTypes.INT;

range_min = 0;                        // int, float
range_max = 10;                       // int, float
number_scale = NumberScales.LINEAR;   // int, float
char_limit = 20;                      // string
type_guid = NULL;                     // Data, enum

max_size = 1;
size_can_be_zero = false;

default_real = 0;
default_int = 0;
default_string = "";
default_code =
@"-- write Lua here";

CreateJSONProperty = function() {
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

CreateJSON = function() {
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