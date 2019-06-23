event_inherited();

// if more data is added here, and i don't think it will be, be
// sure to carry it over in both the save/load scripts and data_clone()

name = "Property";
type = DataTypes.INT;
deleted = false;

range_min = 0;                        // int, float
range_max = 10;                       // int, float
number_scale = NumberScales.LINEAR;   // int, float
char_limit = 20;                      // string
type_guid = 0;                        // Data, enum

max_size = 1;

default_real = 0;
default_int = 0;
default_string = "";
default_code =
@"-- write Lua here";

enum DataTypes {
    INT,            // input
    ENUM,           // list
    FLOAT,          // input
    STRING,         // input
    BOOL,           // checkbox
    DATA,           // list
    CODE,           // opens in text editor
    COLOR,
    MESH,
    TILESET,
    TILE,
    AUTOTILE,
    AUDIO_BGM,
    AUDIO_SE,
}

enum NumberScales {
    LINEAR,
    QUADRATIC,
    EXPONENTIAL,
}