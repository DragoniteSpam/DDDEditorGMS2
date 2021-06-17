event_inherited();

save_script = serialize_save_entity_effect_com_directional_light;
load_script = serialize_load_entity_effect_com_directional_light;
render = render_effect_light_direction;
sprite = spr_light_direction;
light_type = LightTypes.DIRECTIONAL;
label_colour = c_green;

// specific
light_dx = -1;
light_dy = -1;
light_dz = -1;
light_colour = c_white;

instance_deactivate_object(id);

LoadJSONComponentLight = function(source) {
    self.LoadJSONComponent(source);
    self.light_color = source.light.color;
    self.dx = source.light.dx;
    self.dy = source.light.dy;
    self.dz = source.light.dz;
};

LoadJSON = function(source) {
    self.LoadJSONComponentLight(source);
};

CreateJSONDirectionalLight = function() {
    var json = self.CreateJSONComponent();
    json.light = {
        color: self.light_color,
        dx: self.dx,
        dy: self.dy,
        dz: self.dz,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONDirectionalLight();
};
