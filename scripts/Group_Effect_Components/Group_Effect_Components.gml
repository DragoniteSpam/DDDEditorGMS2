function Component(parent, source = undefined) constructor {
    self.parent = parent;
    self.sprite = -1;
    self.label_colour = c_black;
    self.script_call = "";
    self.type = 0;                                                              // used by components to differentiate them from each other
    
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
    
    self.ExportBase = function(buffer) {
        buffer_write(buffer, buffer_u32, self.type);
        buffer_write(buffer, buffer_string, self.script_call);
    };
}

function ComponentPointLight(parent, source = undefined) : Component(parent, source) constructor {
    self.Render = function() {
        if (array_search(Stuff.map.active_map.lights, self.parent.REFID) != -1) {
            var world_x = (self.parent.xx + self.parent.off_xx) * TILE_WIDTH;
            var world_y = (self.parent.yy + self.parent.off_yy) * TILE_HEIGHT;
            var world_z = (self.parent.zz + self.parent.off_zz) * TILE_DEPTH;
            Stuff.graphics.DrawAxesRotation(
                world_x, world_y, world_z, 0, 0, 0,
                self.light_radius / 16, self.light_radius / 16, self.light_radius / 16
            );
        }
    };
    
    self.sprite = spr_light_point;
    self.type = LightTypes.POINT;
    self.label_colour = c_blue;
    
    // specific
    self.light_colour = c_white;
    self.light_radius = 255;
    
    if (is_struct(source)) {
        self.light_colour = source.specific.color;
        self.light_radius = source.specific.radius;
    }
    
    static CreateJSONPointLight = function() {
        var json = self.CreateJSONComponent();
        json.specific = {
            type: self.type,
            color: self.light_colour,
            radius: self.light_radius,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONPointLight();
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.light_colour);
        buffer_write(buffer, buffer_f32, self.light_radius);
    };
}

function ComponentSpotLight(parent, source = undefined) : Component(parent, source) constructor {
    self.Render = function() {
        if (array_search(Stuff.map.active_map.lights, self.parent.REFID) != -1) {
            var world_x = (self.parent.xx + self.parent.off_xx) * TILE_WIDTH;
            var world_y = (self.parent.yy + self.parent.off_yy) * TILE_HEIGHT;
            var world_z = (self.parent.zz + self.parent.off_zz) * TILE_DEPTH;
            Stuff.graphics.DrawAxesRotation(
                world_x, world_y, world_z, 0, 0, 0,
                self.light_radius / 16, self.light_radius / 16, self.light_radius / 16
            );
        }
    };
    
    self.sprite = spr_light_point;
    self.type = LightTypes.SPOT;
    self.label_colour = c_orange;
    
    // specific
    self.light_colour = c_white;
    self.light_radius = 255;
    self.light_cutoff_outer = 45;
    self.light_cutoff_inner = 45;
    self.light_dx = 0;
    self.light_dy = 0;
    self.light_dz = -1;
    
    if (is_struct(source)) {
        self.light_colour = source.specific.color;
        self.light_radius = source.specific.radius;
        self.light_cutoff_outer = source.specific.cutoff_outer;
        self.light_cutoff_inner = source.specific.cutoff_inner;
        self.light_dx = source.specific.dx;
        self.light_dy = source.specific.dy;
        self.light_dz = source.specific.dz;
    }
    
    static CreateJSONSpotLight = function() {
        var json = self.CreateJSONComponent();
        json.specific = {
            type: self.type,
            color: self.light_colour,
            radius: self.light_radius,
            cutoff_outer: self.light_cutoff_outer,
            cutoff_inner: self.light_cutoff_inner,
            dx: self.light_dx,
            dy: self.light_dy,
            dz: self.light_dz,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONSpotLight();
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.light_colour);
        buffer_write(buffer, buffer_f32, self.light_radius);
        buffer_write(buffer, buffer_u32, self.light_cutoff_outer);
        buffer_write(buffer, buffer_u32, self.light_cutoff_inner);
        buffer_write(buffer, buffer_f32, self.light_dx);
        buffer_write(buffer, buffer_f32, self.light_dy);
        buffer_write(buffer, buffer_f32, self.light_dz);
    };
}

function ComponentDirectionalLight(parent, source = undefined) : Component(parent, source) constructor {
    self.Render = function() {
        if (array_search(Stuff.map.active_map.lights, self.parent.REFID) != -1) {
            var world_x = (self.parent.xx + self.parent.off_xx) * TILE_WIDTH;
            var world_y = (self.parent.yy + self.parent.off_yy) * TILE_HEIGHT;
            var world_z = (self.parent.zz + self.parent.off_zz) * TILE_DEPTH;
            Stuff.graphics.DrawAxesRotation(world_x, world_y, world_z, 0, 0, 0, 1, 1, 1);
        }
    };
    
    self.sprite = spr_light_direction;
    self.type = LightTypes.DIRECTIONAL;
    self.label_colour = c_green;
    
    // specific
    self.light_dx = -1;
    self.light_dy = -1;
    self.light_dz = -1;
    self.light_colour = c_white;
    
    if (is_struct(source)) {
        self.light_colour = source.specific.color;
        self.light_dx = source.specific.dx;
        self.light_dy = source.specific.dy;
        self.light_dz = source.specific.dz;
    }
    
    static CreateJSONDirectionalLight = function() {
        var json = self.CreateJSONComponent();
        json.specific = {
            type: self.type,
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
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u32, self.light_colour);
        buffer_write(buffer, buffer_f32, self.light_dx);
        buffer_write(buffer, buffer_f32, self.light_dy);
        buffer_write(buffer, buffer_f32, self.light_dz);
    };
}

function ComponentParticle(parent, source = undefined) : Component(parent, source) constructor {
    self.Render = null;
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
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_datatype, self.particle_guid);
    };
}

function ComponentAudio(parent, source = undefined) : Component(parent, source) constructor {
    self.render = null;
    self.sprite = spr_light_direction;
    
    // specific
    self.audio_guid = NULL;
    
    if (is_struct(source)) {
        self.audio_guid = source.audio.guid;
    };
    
    static CreateJSONAudio = function() {
        var json = self.CreateJSONComponent();
        json.audio = {
            guid: self.audio_guid,
        };
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONAudio();
    };
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_datatype, self.audio_guid);
    };
}