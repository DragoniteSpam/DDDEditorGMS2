function Component(parent, source) constructor {
    self.parent = parent;
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
    
    static ExportBase = function(buffer) {
        buffer_write(buffer, buffer_string, self.script_call);
    };
}

function ComponentPointLight(parent, source) : Component(parent, source) constructor {
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
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.light_colour);
        buffer_write(buffer, buffer_f32, self.light_radius);
    };
}

function ComponentSpotLight(parent, source) : Component(parent, source) constructor {
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
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.light_colour);
        buffer_write(buffer, buffer_f32, self.light_radius);
        buffer_write(buffer, buffer_u32, self.light_cutoff);
        buffer_write(buffer, buffer_f32, self.light_dx);
        buffer_write(buffer, buffer_u32, self.light_dy);
        buffer_write(buffer, buffer_f32, self.light_dz);
    };
}

function ComponentDirectionalLight(parent, source) : Component(parent, source) constructor {
    self.render = render_effect_light_direction;
    self.sprite = spr_light_direction;
    self.light_type = LightTypes.DIRECTIONAL;
    self.label_colour = c_green;
    
    // specific
    self.light_dx = -1;
    self.light_dy = -1;
    self.light_dz = -1;
    self.light_colour = c_white;
    
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
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.light_colour);
        buffer_write(buffer, buffer_f32, self.light_dx);
        buffer_write(buffer, buffer_u32, self.light_dy);
        buffer_write(buffer, buffer_f32, self.light_dz);
    };
}

function ComponentParticle(parent, source) : Component(parent, source) constructor {
    self.save_script = null;
    self.render = null;
    self.sprite = spr_light_direction;
    
    // specific
    self.particle_guid = NULL;
    
    if (is_struct(source)) {
        self.particle_guid = source.particle.guid;
    };
    
    static CreateJSONParticle = function() {
        var json = self.CreateJSONComponent();
        json.particle = {
            guid: self.particle_guid,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONParticle();
    };
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_datatype, self.particle_guid);
    };
}

function ComponentAudio(parent, source) : Component(parent, source) constructor {
    self.save_script = null;
    self.render = null;
    self.sprite = spr_light_direction;
    
    // specific
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
    
    static Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.audio_type);
    };
}