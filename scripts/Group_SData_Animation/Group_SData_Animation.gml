function DataAnimation(name) : SData(name) constructor {
    self.frames_per_second = 24;
    self.moments = self.frames_per_second * 2;
    self.loops = true;
    
    self.code = Stuff.default_lua_animation;
    
    // list of Layer objects with priority queues of Keyframe objects
    self.layers = [new DataAnimationLayer(self, "Layer 0")];
    self.layers[0].keyframes = array_create(self.moments);
    self.layers[0].is_actor = true;
    
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
    
    static GetNextKeyframe = function(layer, moment, ignore_passthrough) {
        if (ignore_passthrough == undefined) ignore_passthrough = false;
        for (var i = moment + 1; i < self.moments; i++) {
            var keyframe = self.GetKeyframe(layer, i);
            if (keyframe && (!ignore_passthrough || keyframe.HasTween())) return keyframe;
        }
        
        return undefined;
    };
    
    static GetPreviousKeyframe = function(layer, moment, ignore_passthrough) {
        if (ignore_passthrough == undefined) ignore_passthrough = false;
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

function DataAnimationLayer(animation, name) constructor {
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
    self.name = name;
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
    self.graphic_sprite = undefined;
    self.graphic_mesh = undefined;
    self.graphic_frame = 0;
    
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
    
    static GetNextKeyframe = function(moment, ignore_passthrough) {
        if (ignore_passthrough == undefined) ignore_passthrough = false;
        for (var i = moment + 1; i < self.animation.moments; i++) {
            var keyframe = self.GetKeyframe(i);
            if (keyframe && (!ignore_passthrough || keyframe.HasTween())) return keyframe;
        }
        
        return undefined;
    };
    
    static GetPreviousKeyframe = function(moment, ignore_passthrough) {
        if (ignore_passthrough == undefined) ignore_passthrough = false;
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
        // if not next keyframe exists the value will always be the previous value
        var value_default = self.GetBaseValue(param);
        var value_now = (kf_current ? kf_current.Get(param) : value_default) + (rel_current ? rel_current.GetBaseValue(param) : 0);
        var value_previous = (kf_previous ? kf_previous.Get(param) : value_default) + (rel_previous ? rel_previous.GetBaseValue(param) : 0);
        var value_next = (kf_next ? kf_next.Get(param) : (self.animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.GetBaseValue(param) : 0);
        var moment_previous = kf_previous ? kf_previous.moment : 0;
        var moment_next = kf_next ? kf_next.moment : self.animation.moments;
        var f = normalize(moment, moment_previous, moment_next);
        
        if (kf_current && kf_current.HasParameterTween(param)) return value_now;
        
        // only need to check for previous keyframe because if there is no next keyframe, the "next"
        // value will be the same as previous and tweening will just output the same value anyway
        return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.GetParameterTween(param) : AnimationTweens.NONE);
    };
}

enum GraphicTypes {
    NONE,
    NO_CHANGE,
    SPRITE,
    MESH
}

function DataAnimationKeyframe(layer, moment) constructor {
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
    self.relative = -1;
    self.moment = moment;
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
        x: AnimationTweens.NONE,
        y: AnimationTweens.NONE,
        z: AnimationTweens.NONE,
        xrot: AnimationTweens.NONE,
        yrot: AnimationTweens.NONE,
        zrot: AnimationTweens.NONE,
        xscale: AnimationTweens.NONE,
        yscale: AnimationTweens.NONE,
        zscale: AnimationTweens.NONE,
        color: AnimationTweens.NONE,
        alpha: AnimationTweens.NONE,
        r: AnimationTweens.NONE,
        g: AnimationTweens.NONE,
        b: AnimationTweens.NONE,
    };
    
    self.moment = 0;
    self.timeline_layer = 0;
    
    static Get = function(param) {
        return self.tween[$ property_map[$ param]];
    };
    
    static Set = function(param, value) {
        self.tween[$ property_map[$ param]] = value;
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
        return tween != AnimationTweens.NONE && tween != AnimationTweens.IGNORE;
    };
    
    static SetParameterTween = function(param, value) {
        self.tween[$ property_map[$ param]] = value;
    };
    
    static HasParameterTween = function(param) {
        return self.tween[$ property_map[$ param]] != AnimationTweens.IGNORE;
    };
}

enum KeyframeParameters {
    TRANS_X, TRANS_Y, TRANS_Z,
    ROT_X, ROT_Y, ROT_Z,
    SCALE_X, SCALE_Y, SCALE_Z,
    COLOR, ALPHA,
    COLOR_R, COLOR_G, COLOR_B,
}