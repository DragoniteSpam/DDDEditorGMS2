function DataAnimationKeyframe() constructor {
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
    };
    
    self.moment = 0;
    self.timeline_layer = 0;
    
    static CreateJSONAnimKeyframe = function() {
        var json = { };
        json.relative = self.relative;
        json.xx = self.xx;
        json.yy = self.yy;
        json.zz = self.zz;
        json.xrot = self.xrot;
        json.yrot = self.yrot;
        json.zrot = self.zrot;
        json.xscale = self.xscale;
        json.yscale = self.yscale;
        json.zscale = self.zscale;
        json.color = self.color;
        json.alpha = self.alpha;
        json.audio = self.audio;
        
        json.graphic_type = self.graphic_type;
        json.graphic_sprite = self.graphic_sprite;
        json.graphic_mesh = self.graphic_mesh;
        json.graphic_frame = self.graphic_frame;
        json.graphic_direction = self.graphic_direction;
        
        json.tween = self.tween;
        
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONAnimKeyframe();
    };
}

enum KeyframeParameters {
    TRANS_X, TRANS_Y, TRANS_Z,
    ROT_X, ROT_Y, ROT_Z,
    SCALE_X, SCALE_Y, SCALE_Z,
    COLOR, ALPHA
}