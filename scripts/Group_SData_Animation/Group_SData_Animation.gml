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
}

enum KeyframeParameters {
    TRANS_X, TRANS_Y, TRANS_Z,
    ROT_X, ROT_Y, ROT_Z,
    SCALE_X, SCALE_Y, SCALE_Z,
    COLOR, ALPHA,
    COLOR_R, COLOR_G, COLOR_B,
}