function DataAnimation(name) : SData(name) constructor {
    // list of Layer objects with priority queues of Keyframe objects
    self.layers = [new DataAnimationLayer("Layer 0")];
    self.layers[0].is_actor = true;
    
    self.frames_per_second = 24;
    self.moments = self.frames_per_second * 2;
    self.loops = true;
    
    self.code = Stuff.default_lua_animation;
    
    repeat (self.moments) {
        ds_list_add(self.layers[0].keyframes, undefined);
    }
    
    static AddLayer = function() {
        var layer = new DataAnimationLayer("Layer " + string(array_length(self.layers)));
        array_push(self.layers, layer);
    };
    
    static GetLayer = function(layer) {
        if (layer < array_length(self.layers)) return self.layers[layer];
        return undefined;
    };
    
    static AddKeyframe = function(layer, moment) {
        var inst_layer = self.GetLayer(layer);
        var keyframe = new DataAnimationKeyframe();
        
        keyframe.moment = moment;
        keyframe.timeline_layer = timeline_layer;
        keyframe.relative = timeline_layer;
        inst_layer.keyframes[| moment] = keyframe;
        
        return keyframe;
    };
    
    static GetKeyframe = function(layer, moment) {
        var timeline_layer = self.GetLayer(layer);
        if (timeline_layer) return timeline_layer.keyframes[| moment];
        return undefined;
    };
    
    static GetNextKeyframe = function(layer, moment) {
        for (var i = moment + 1; i < self.moments; i++) {
            var keyframe = self.GetKeyframe(layer, i);
            if (keyframe) return keyframe;
        }
        
        return undefined;
    };
    
    static GetPreviousKeyframe = function(layer, moment) {
        for (var i = moment - 1; i >= 0; i--) {
            var keyframe = self.GetKeyframe(layer, i);
            if (keyframe) return keyframe;
        }
        
        return undefined;
    };
    
    static SetKeyframePosition = function(layer, keyframe, moment) {
        var inst_layer = self.GetLayer(layer);
        inst_layer.keyframes[| keyframe.moment] = noone;
        keyframe.moment = moment;
        inst_layer.keyframes[| moment] = keyframe;
        return keyframe;
    };
}

function DataAnimationLayer(name) constructor {
    self.name = name;
    self.is_actor = false;
    self.keyframes = [];
    
    // base values
    self.xx = 0;
    self.yy = 0;
    self.zz = 0;
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
}

enum GraphicTypes {
    NONE,
    NO_CHANGE,
    SPRITE,
    MESH
}

function DataAnimationKeyframe() constructor {
    static property_map = { };
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
    
    static GetParameter = function(param) {
        return self.tween[$ property_map[$ param]];
    };
    
    static SetParameter = function(param, value) {
        self.tween[$ property_map[$ param]] = value;
    };
    
    static GetHasTween = function() {
        var members = variable_struct_get_names(self.tween);
        for (var i = 0; i < array_length(members); i++) {
            var tween = self.tween[$ property_map[$ param]];
            if (tween != AnimationTweens.NONE && tween != AnimationTweens.IGNORE) return true;
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
}

enum KeyframeParameters {
    TRANS_X, TRANS_Y, TRANS_Z,
    ROT_X, ROT_Y, ROT_Z,
    SCALE_X, SCALE_Y, SCALE_Z,
    COLOR, ALPHA,
    COLOR_R, COLOR_G, COLOR_B,
}