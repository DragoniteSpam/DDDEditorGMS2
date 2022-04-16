function DataAnimation(source) : SData(source) constructor {
    self.frames_per_second = 24;
    self.moments = self.frames_per_second * 2;
    self.loops = true;
    
    self.code = "";
    
    if (is_struct(source)) {
        self.frames_per_second = source.frames_per_second;
        self.moments = source.moments;
        self.loops = source.loops;
        self.code = source.code;
        self.layers = source.layers;
        
        for (var i = 0, n = array_length(self.layers); i < n; i++) {
            self.layers[i] = new DataAnimationLayer(self, self.layers[i]);
        }
    } else {
        self.layers = [new DataAnimationLayer(self, "Layer 0")];
        self.layers[0].keyframes = array_create(self.moments);
        self.layers[0].is_actor = true;
    }
    
    self.Export = function(buffer) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u8, self.frames_per_second);
        buffer_write(buffer, buffer_u16, self.moments);
        buffer_write(buffer, buffer_string, self.code);
        
        buffer_write(buffer, buffer_field, pack(
            self.loops
        ));
        
        var n_layers = array_length(self.layers);
        buffer_write(buffer, buffer_u32, n_layers);
        
        for (var j = 0; j < n_layers; j++) {
            self.layers[j].Export(buffer);
        }
    };
    
    static CreateJSON = function() {
        var json = self.CreateJSONBase();
        json.frames_per_second = self.frames_per_second;
        json.moments = self.moments;
        json.loops = self.loops;
        json.code = self.code;
        
        json.layers = array_create(array_length(self.layers));
        for (var i = 0, n = array_length(self.layers); i < n; i++) {
            json.layers[i] = self.layers[i].CreateJSON();
        }
        
        return json;
    }
    
    static AddLayer = function() {
        var new_layer = new DataAnimationLayer(self, "Layer " + string(array_length(self.layers)));
        array_push(self.layers, new_layer);
        return new_layer;
    };
    
    static GetLayer = function(layer) {
        if (layer < array_length(self.layers)) return self.layers[layer];
        return undefined;
    };
    
    static AddKeyframe = function(layer, moment) {
        return self.GetLayer(layer).AddKeyframe(moment);
    };
    
    static GetKeyframe = function(layer, moment) {
        var timeline_layer = self.GetLayer(layer);
        if (timeline_layer) return timeline_layer.keyframes[moment];
        return undefined;
    };
    
    static GetNextKeyframe = function(layer, moment, ignore_passthrough = false) {
        for (var i = moment + 1; i < self.moments; i++) {
            var keyframe = self.GetKeyframe(layer, i);
            if (keyframe && (!ignore_passthrough || keyframe.HasTween())) return keyframe;
        }
        
        return undefined;
    };
    
    static GetPreviousKeyframe = function(layer, moment, ignore_passthrough = false) {
        for (var i = moment - 1; i >= 0; i--) {
            var keyframe = self.GetKeyframe(layer, i);
            if (keyframe && (!ignore_passthrough || keyframe.HasTween())) return keyframe;
        }
        
        return undefined;
    };
    
    static SetKeyframePosition = function(layer, keyframe, moment) {
        var inst_layer = self.GetLayer(layer);
        inst_layer.keyframes[keyframe.moment] = noone;
        keyframe.moment = moment;
        inst_layer.keyframes[moment] = keyframe;
        return keyframe;
    };
    
    static GetValue = function(layer, moment, param) {
        return self.layers[layer].GetValue(moment, param);
    };
    
    static SetLength = function(moments) {
        self.moments = moments;
        for (var i = 0; i < array_length(self.layers); i++) {
            self.layers[i].SetLength(moments);
        }
    };
}

function DataAnimationLayer(animation, source) constructor {
    static property_map = undefined;
    if (!property_map) {
        property_map = { };
        property_map[$ KeyframeParameters.TRANS_X] = "x";
        property_map[$ KeyframeParameters.TRANS_Y] = "y";
        property_map[$ KeyframeParameters.TRANS_Z] = "z";
        property_map[$ KeyframeParameters.ROT_X] = "xrot";
        property_map[$ KeyframeParameters.ROT_Y] = "yrot";
        property_map[$ KeyframeParameters.ROT_Z] = "zrot";
        property_map[$ KeyframeParameters.SCALE_X] = "xscale";
        property_map[$ KeyframeParameters.SCALE_Y] = "yscale";
        property_map[$ KeyframeParameters.SCALE_Z] = "zscale";
        property_map[$ KeyframeParameters.COLOR] = "color";
        property_map[$ KeyframeParameters.ALPHA] = "alpha";
        property_map[$ KeyframeParameters.COLOR_R] = "r";
        property_map[$ KeyframeParameters.COLOR_G] = "g";
        property_map[$ KeyframeParameters.COLOR_B] = "b";
    }
    
    self.animation = animation;
    self.is_actor = false;
    self.keyframes = [];
    
    // base values
    self.x = 0;
    self.y = 0;
    self.z = 0;
    self.xrot = 0;
    self.yrot = 0;
    self.zrot = 0;
    self.xscale = 1;
    self.yscale = 1;
    self.zscale = 1;
    self.color = c_white;
    self.alpha = 1;
    
    self.graphic_type = GraphicTypes.NO_CHANGE;
    self.graphic_sprite = NULL;
    self.graphic_mesh = NULL;
    self.graphic_frame = 0;
    
    if (is_struct(source)) {
        self.name = source.name;
        self.is_actor = source.is_actor;
        self.x = source.x;
        self.y = source.y;
        self.z = source.z;
        self.xrot = source.xrot;
        self.yrot = source.yrot;
        self.zrot = source.zrot;
        self.xscale = source.xscale;
        self.yscale = source.yscale;
        self.zscale = source.zscale;
        self.color = source.color;
        self.alpha = source.alpha;
        
        self.graphic_type = source.graphic_type;
        self.graphic_sprite = source.graphic_sprite;
        self.graphic_mesh = source.graphic_mesh;
        self.graphic_frame = source.graphic_frame;
        
        self.keyframes = source.keyframes;
        
        for (var i = 0, n = array_length(self.keyframes); i < n; i++) {
            if (is_struct(self.keyframes[i])) {
                self.keyframes[i] = new DataAnimationKeyframe(self, i, self.keyframes[i]);
            } else {
                self.keyframes[i] = undefined;
            }
        }
    } else {
        self.name = source;
    }
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_string, self.name);
        
        buffer_write(buffer, buffer_field, pack(
            self.is_actor
        ));
    
        buffer_write(buffer, buffer_f32, self.x);
        buffer_write(buffer, buffer_f32, self.y);
        buffer_write(buffer, buffer_f32, self.z);
        buffer_write(buffer, buffer_f32, self.xrot);
        buffer_write(buffer, buffer_f32, self.yrot);
        buffer_write(buffer, buffer_f32, self.zrot);
        buffer_write(buffer, buffer_f32, self.xscale);
        buffer_write(buffer, buffer_f32, self.yscale);
        buffer_write(buffer, buffer_f32, self.zscale);
        buffer_write(buffer, buffer_u32, self.color);
        buffer_write(buffer, buffer_f32, self.alpha);
        buffer_write(buffer, buffer_u8, self.graphic_type);
        buffer_write(buffer, buffer_datatype, self.graphic_sprite);
        buffer_write(buffer, buffer_datatype, self.graphic_mesh);
        
        var n_keyframes = array_length(self.keyframes);
        buffer_write(buffer, buffer_u16, n_keyframes);
        
        for (var i = 0; i < n_keyframes; i++) {
            buffer_write(buffer, buffer_bool, !!self.keyframes[i]);
            if (self.keyframes[i]) self.keyframes[i].Export(buffer);
        }
    };
    
    static CreateJSON = function() {
        var json = {
            name: self.name,
            is_actor: self.is_actor,
            
            x: self.x,
            y: self.y,
            z: self.z,
            xrot: self.xrot,
            yrot: self.yrot,
            zrot: self.zrot,
            xscale: self.xscale,
            yscale: self.yscale,
            zscale: self.zscale,
            color: self.color,
            alpha: self.alpha,
            
            graphic_type: self.graphic_type,
            graphic_sprite: self.graphic_sprite,
            graphic_mesh: self.graphic_mesh,
            graphic_frame: self.graphic_frame,
            
            keyframes: array_create(array_length(self.keyframes), undefined),
        };
        
        for (var i = 0, n = array_length(self.keyframes); i < n; i++) {
            if (self.keyframes[i]) json.keyframes[i] = self.keyframes[i].CreateJSON();
        }
        
        return json;
    };
    
    static SetLength = function(moments) {
        var old_moments = array_length(self.keyframes);
        array_resize(self.keyframes, moments);
        for (var i = old_moments; i < moments; i++) {
            self.keyframes[i] = undefined;
        }
    };
    
    static AddKeyframe = function(moment) {
        self.keyframes[moment] = new DataAnimationKeyframe(self, moment);
        return self.keyframes[moment];
    };
    
    static GetKeyframe = function(moment) {
        return self.keyframes[moment];
    };
    
    static GetNextKeyframe = function(moment, ignore_passthrough = false) {
        for (var i = moment + 1; i < self.animation.moments; i++) {
            var keyframe = self.GetKeyframe(i);
            if (keyframe && (!ignore_passthrough || keyframe.HasTween())) return keyframe;
        }
        
        return undefined;
    };
    
    static GetPreviousKeyframe = function(moment, ignore_passthrough = false) {
        for (var i = moment - 1; i >= 0; i--) {
            var keyframe = self.GetKeyframe(i);
            if (keyframe && (!ignore_passthrough || keyframe.HasTween())) return keyframe;
        }
        
        return undefined;
    };
    
    static GetBaseValue = function(param) {
        return self[$ property_map[$ param]];
    };
    
    static SetBaseValue = function(param, value) {
        self[$ property_map[$ param]] = value; 
    };
    
    static GetValue = function(moment, param) {
        var kf_current = self.GetKeyframe(moment);
        var kf_previous = self.GetPreviousKeyframe(moment, true);
        var kf_next = self.GetNextKeyframe(moment, true);
        
        var rel_current = (kf_current && kf_current.relative > -1) ? self.animation.layers[kf_current.relative] : undefined;
        var rel_previous = (kf_previous && kf_previous.relative > -1) ? self.animation.layers[kf_previous.relative] : undefined;
        var rel_next = (kf_next && kf_next.relative > -1) ? self.animation.layers[kf_next.relative] : undefined;
        
        // if no previous keyframe exists the value will always be the default (here, zero);
        // if no next keyframe exists the value will always be the previous value
        var value_default = self.GetBaseValue(param);
        var value_now = (kf_current ? kf_current.Get(param) : value_default) + (rel_current ? rel_current.GetBaseValue(param) : 0);
        var value_previous = (kf_previous ? kf_previous.Get(param) : value_default) + (rel_previous ? rel_previous.GetBaseValue(param) : 0);
        var value_next = (kf_next ? kf_next.Get(param) : (self.animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.GetBaseValue(param) : 0);
        var moment_previous = kf_previous ? kf_previous.moment : 0;
        var moment_next = kf_next ? kf_next.moment : self.animation.moments;
        var f = adjust_range(moment, moment_previous, moment_next);
        
        if (kf_current && kf_current.HasParameterTween(param)) return value_now;
        
        // only need to check for previous keyframe because if there is no next keyframe, the "next"
        // value will be the same as previous and tweening will just output the same value anyway
        return ease(value_previous, value_next, f, kf_previous ? kf_previous.GetParameterTween(param) : Easings.NONE);
    };
}

enum GraphicTypes {
    NONE,
    NO_CHANGE,
    SPRITE,
    MESH
}

function DataAnimationKeyframe(layer, moment, source = undefined) constructor {
    static property_map = undefined;
    if (!property_map) {
        property_map = { };
        property_map[$ KeyframeParameters.TRANS_X] = "x";
        property_map[$ KeyframeParameters.TRANS_Y] = "y";
        property_map[$ KeyframeParameters.TRANS_Z] = "z";
        property_map[$ KeyframeParameters.ROT_X] = "xrot";
        property_map[$ KeyframeParameters.ROT_Y] = "yrot";
        property_map[$ KeyframeParameters.ROT_Z] = "zrot";
        property_map[$ KeyframeParameters.SCALE_X] = "xscale";
        property_map[$ KeyframeParameters.SCALE_Y] = "yscale";
        property_map[$ KeyframeParameters.SCALE_Z] = "zscale";
        property_map[$ KeyframeParameters.COLOR] = "color";
        property_map[$ KeyframeParameters.ALPHA] = "alpha";
        property_map[$ KeyframeParameters.COLOR_R] = "r";
        property_map[$ KeyframeParameters.COLOR_G] = "g";
        property_map[$ KeyframeParameters.COLOR_B] = "b";
    }
    
    self.layer = layer;
    self.moment = moment;
    self.relative = -1;
    self.xx = 0;
    self.yy = 0;
    self.zz = 0;
    self.xrot = 0;
    self.yrot = 0;
    self.zrot = 0;
    self.xscale = 1;
    self.yscale = 1;
    self.zscale = 1;
    
    // the different color channels should probably all be tweened individually, instead of
    // just going from color1 to color2 as a whole, because that tends to not work very well
    // when you cross hues
    self.color = c_white;
    self.alpha = 1;
    
    self.audio = NULL;
    self.graphic_type = GraphicTypes.NO_CHANGE;
    self.graphic_sprite = NULL; 
    self.graphic_mesh = NULL;
    self.graphic_frame = 0;
    self.graphic_direction = 0;
    self.event = "";     // lua function name (i.e. "invoke")
    
    // tweens
    self.tween = {
        x: Easings.NONE,
        y: Easings.NONE,
        z: Easings.NONE,
        xrot: Easings.NONE,
        yrot: Easings.NONE,
        zrot: Easings.NONE,
        xscale: Easings.NONE,
        yscale: Easings.NONE,
        zscale: Easings.NONE,
        color: Easings.NONE,
        alpha: Easings.NONE,
        r: Easings.NONE,
        g: Easings.NONE,
        b: Easings.NONE,
    };
    
    if (source) {
        self.relative = source.relative;
        self.x = source.x;
        self.y = source.y;
        self.z = source.z;
        self.xrot = source.xrot;
        self.yrot = source.yrot;
        self.zrot = source.zrot;
        self.xscale = source.xscale;
        self.yscale = source.yscale;
        self.zscale = source.zscale;
        self.color = source.color;
        self.alpha = source.color;
        self.graphic_type = source.graphic_type;
        self.graphic_sprite = source.graphic_sprite;
        self.graphic_mesh = source.graphic_mesh;
        self.graphic_frame = source.graphic_frame;
        self.graphic_direction = source.graphic_direction;
        self.event = source.event;
        self.audio = source.audio;
        self.tween = source.tween;
    }
    
    self.Export = function(buffer) {
        buffer_write(buffer, buffer_s32, self.relative);
        buffer_write(buffer, buffer_f32, self.x);
        buffer_write(buffer, buffer_f32, self.y);
        buffer_write(buffer, buffer_f32, self.z);
        buffer_write(buffer, buffer_f32, self.xrot);
        buffer_write(buffer, buffer_f32, self.yrot);
        buffer_write(buffer, buffer_f32, self.zrot);
        buffer_write(buffer, buffer_f32, self.xscale);
        buffer_write(buffer, buffer_f32, self.yscale);
        buffer_write(buffer, buffer_f32, self.zscale);
        buffer_write(buffer, buffer_u32, self.color);
        buffer_write(buffer, buffer_f32, self.alpha);
        buffer_write(buffer, buffer_u8, self.graphic_type);
        buffer_write(buffer, buffer_datatype, self.graphic_sprite);
        buffer_write(buffer, buffer_datatype, self.graphic_mesh);
        buffer_write(buffer, buffer_u32, self.graphic_frame);
        buffer_write(buffer, buffer_u8, self.graphic_direction);
        buffer_write(buffer, buffer_datatype, self.audio);
        buffer_write(buffer, buffer_string, self.event);
        buffer_write(buffer, buffer_u16, self.tween.x);
        buffer_write(buffer, buffer_u16, self.tween.y);
        buffer_write(buffer, buffer_u16, self.tween.z);
        buffer_write(buffer, buffer_u16, self.tween.xrot);
        buffer_write(buffer, buffer_u16, self.tween.yrot);
        buffer_write(buffer, buffer_u16, self.tween.zrot);
        buffer_write(buffer, buffer_u16, self.tween.xscale);
        buffer_write(buffer, buffer_u16, self.tween.yscale);
        buffer_write(buffer, buffer_u16, self.tween.zscale);
        buffer_write(buffer, buffer_u16, self.tween.color);
        buffer_write(buffer, buffer_u16, self.tween.alpha);
    };
    
    static CreateJSON = function() {
        return {
            relative: self.relative,
            x: self.x,
            y: self.y,
            z: self.z,
            xrot: self.xrot,
            yrot: self.yrot,
            zrot: self.zrot,
            xscale: self.xscale,
            yscale: self.yscale,
            zscale: self.zscale,
            color: self.color,
            alpha: self.color,
            audio: self.audio,
            graphic_type: self.graphic_type,
            graphic_sprite: self.graphic_sprite,
            graphic_mesh: self.graphic_mesh,
            graphic_frame: self.graphic_frame,
            graphic_direction: self.graphic_direction,
            event: self.event,
            tween: self.tween,
        };
    };
    
    static Get = function(param) {
        return self[$ property_map[$ param]];
    };
    
    static Set = function(param, value) {
        self[$ property_map[$ param]] = value;
    };
    
    static HasTween = function() {
        var members = variable_struct_get_names(self.tween);
        for (var i = 0; i < array_length(members); i++) {
            if (self.HasParameterTween(i)) return true;
        }
        
        return false;
    };
    
    static GetParameterTween = function(param) {
        var tween = self.tween[$ property_map[$ param]];
        return tween != Easings.NONE;
    };
    
    static SetParameterTween = function(param, value) {
        self.tween[$ property_map[$ param]] = value;
    };
    
    static HasParameterTween = function(param) {
        return self.tween[$ property_map[$ param]] != Easings.NONE;
    };
}

enum KeyframeParameters {
    TRANS_X, TRANS_Y, TRANS_Z,
    ROT_X, ROT_Y, ROT_Z,
    SCALE_X, SCALE_Y, SCALE_Z,
    COLOR, ALPHA,
    COLOR_R, COLOR_G, COLOR_B,
}