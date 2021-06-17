event_inherited();

save_script = serialize_save_entity_effect_com_point_light;
load_script = serialize_load_entity_effect_com_point_light;
render = render_effect_light_point;
sprite = spr_light_point;
light_type = LightTypes.POINT;
label_colour = c_blue;

// specific
light_colour = c_white;
light_radius = 255;

LoadJSONComponentLight = function(source) {
    self.LoadJSONComponent(source);
    self.light_color = source.light.color;
    self.light_radius = source.light.radius;
};

LoadJSON = function(source) {
    self.LoadJSONComponentLight(source);
};

CreateJSONPointLight = function() {
    var json = self.CreateJSONComponent();
    json.light = {
        color: self.light_color,
        radius: self.light_radius,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONPointLight();
};
