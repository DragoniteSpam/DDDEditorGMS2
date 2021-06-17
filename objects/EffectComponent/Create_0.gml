save_script = serialize_save_entity_effect_com;
load_script = serialize_load_entity_effect_com;

parent = noone;
sprite = -1;
label_colour = c_black;

script_call = "";

LoadJSONComponent = function(source) {
    self.LoadJSON(source);
    self.script_call = source.com.code;
};

LoadJSON = function(source) {
    self.LoadJSONComponent(source);
};

CreateJSONComponent = function() {
    var json = self.CreateJSONBase();
    json.com = {
        code: self.script_call,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONComponent();
};
