function Component(source) constructor {
    self.save_script = serialize_save_entity_effect_com;
    self.load_script = serialize_load_entity_effect_com;
    self.parent = undefined;
    self.sprite = -1;
    self.label_colour = c_black;
    self.script_call = "";
    
    if (is_struct(source)) {
        self.script_call = source.com.code;
    }
    
    static CreateJSONComponent = function() {
        var json = {
            com: {
                code: self.script_call,
            },
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONComponent();
    };
}

function ComponentPointLight(source) : Component(source) constructor {
    self.save_script = serialize_save_entity_effect_com_point_light;
    self.load_script = serialize_load_entity_effect_com_point_light;
    self.render = render_effect_light_point;
    self.sprite = spr_light_point;
    self.light_type = LightTypes.POINT;
    self.label_colour = c_blue;
    
    // specific
    self.light_colour = c_white;
    self.light_radius = 255;
    
    if (is_struct(source)) {
        self.light_colour = source.light.color;
        self.light_radius = source.light.radius;
    }
    
    static CreateJSONPointLight = function() {
        var json = self.CreateJSONComponent();
        json.light = {
            color: self.light_colour,
            radius: self.light_radius,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONPointLight();
    };
}



function ComponentSpotLight(source) : Component(source) constructor {
    self.save_script = serialize_save_entity_effect_com_spot_light;
    self.load_script = serialize_load_entity_effect_com_spot_light;
    self.render = render_effect_light_spot;
    self.sprite = spr_light_point;
    self.light_type = LightTypes.SPOT;
    self.label_colour = c_orange;
    
    // specific
    self.light_colour = c_white;
    self.light_radius = 255;
    self.light_cutoff = 45;
    self.light_dx = 0;
    self.light_dy = 0;
    self.light_dz = -1;
    
    if (is_struct(source)) {
        self.light_colour = source.light.color;
        self.light_radius = source.light.radius;
        self.light_cutoff = source.light.cutoff;
        self.light_dx = source.light.dx;
        self.light_dy = source.light.dy;
        self.light_dz = source.light.dz;
    }
    
    static CreateJSONSpotLight = function() {
        var json = self.CreateJSONComponent();
        json.light = {
            color: self.light_colour,
            radius: self.light_radius,
            cutoff: self.light_cutoff,
            dx: self.light_dx,
            dy: self.light_dy,
            dz: self.light_dz,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONSpotLight();
    };
}

function ComponentDirectionalLight(source) : Component(source) constructor {
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
    
    if (is_struct(source)) {
        self.light_colour = source.light.color;
        self.light_dx = source.light.dx;
        self.light_dy = source.light.dy;
        self.light_dz = source.light.dz;
    }
    
    static CreateJSONDirectionalLight = function() {
        var json = self.CreateJSONComponent();
        json.light = {
            color: self.light_colour,
            dx: self.light_dx,
            dy: self.light_dy,
            dz: self.light_dz,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONDirectionalLight();
    };
}

function ComponentParticle(source) : Component(source) constructor {
    self.save_script = null;
    self.load_script = null;
    self.render = null;
    self.sprite = spr_light_direction;
    self.particle_type = ParticleTypes.NONE;
    
    if (is_struct(source)) {
        self.particle_type = source.particle.type;
    };
    
    static CreateJSONParticle = function() {
        var json = self.CreateJSONComponent();
        json.particle = {
            type: self.particle_type,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONParticle();
    };
}

function ComponentAudio(source) : Component(source) constructor {
    self.save_script = null;
    self.load_script = null;
    self.render = null;
    self.sprite = spr_light_direction;
    self.audio_type = AudioTypes.NONE;
    
    if (is_struct(source)) {
        self.audio_type = source.audio.type;
    };
    
    static CreateJSONAudio = function() {
        var json = self.CreateJSONComponent();
        json.audio = {
            type: self.audio_type,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONAudio();
    };
}