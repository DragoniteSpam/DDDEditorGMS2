event_inherited();

save_script = serialize_save_entity_effect_com_spot_light;
load_script = serialize_load_entity_effect_com_spot_light;
render = render_effect_light_spot;
sprite = spr_light_point;
light_type = LightTypes.SPOT;
label_colour = c_orange;

// specific
light_colour = c_white;
light_radius = 255;
light_cutoff = 45;
light_dx = 0;
light_dy = 0;
light_dz = -1;

LoadJSONComponentLight = function(source) {
    self.LoadJSONComponent(source);
    self.light_color = source.light.color;
    self.light_radius = source.light.radius;
    self.light_cutoff = source.light.cutoff;
    self.dx = source.light.dx;
    self.dy = source.light.dy;
    self.dz = source.light.dz;
};

LoadJSON = function(source) {
    self.LoadJSONComponentLight(source);
};

CreateJSONSpotLight = function() {
    var json = self.CreateJSONComponent();
    json.light = {
        color: self.light_color,
        radius: self.light_radius,
        cutoff: self.light_cutoff,
        dx: self.dx,
        dy: self.dy,
        dz: self.dz,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONSpotLight();
};
