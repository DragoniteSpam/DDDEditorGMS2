relative = -1;

xx = 0;
yy = 0;
zz = 0;
xrot = 0;
yrot = 0;
zrot = 0;
xscale = 1;
yscale = 1;
zscale = 1;

// the different color channels should probably all be tweened individually, instead of
// just going from color1 to color2 as a whole, because that tends to not work very well
// when you cross hues
color = c_white;
alpha = 1;

audio = 0;

graphic_type = GraphicTypes.NO_CHANGE;
graphic_sprite = noone; 
graphic_mesh = noone;
graphic_frame = 0;
graphic_direction = 0;

event = "";     // lua function name (i.e. "invoke")

// tweens

tween.x = AnimationTweens.NONE;
tween.y = AnimationTweens.NONE;
tween.z = AnimationTweens.NONE;
tween.xrot = AnimationTweens.NONE;
tween.yrot = AnimationTweens.NONE;
tween.zrot = AnimationTweens.NONE;
tween.xscale = AnimationTweens.NONE;
tween.yscale = AnimationTweens.NONE;
tween.zscale = AnimationTweens.NONE;

tween.color = AnimationTweens.NONE;
tween.alpha = AnimationTweens.NONE;

moment = 0;
timeline_layer = 0;

CreateJSONAnimKeyframe = function() {
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
    
    json.tween = {
        x: self.tween.x,
        y: self.tween.y,
        z: self.tween.z,
        xrot: self.tween.xrot,
        yrot: self.tween.yrot,
        zrot: self.tween.zrot,
        xscale: self.tween.xscale,
        yscale: self.tween.yscale,
        zscale: self.tween.zscale,
        color: self.tween.color,
        alpha: self.tween.alpha,
    };
    
    return json;
};

CreateJSON = function() {
    return self.CreateJSONAnimKeyframe();
};

enum KeyframeParameters {
    TRANS_X, TRANS_Y, TRANS_Z,
    ROT_X, ROT_Y, ROT_Z,
    SCALE_X, SCALE_Y, SCALE_Z,
    COLOR, ALPHA
}