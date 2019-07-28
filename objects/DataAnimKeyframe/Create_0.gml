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

event = noone;

tween_xx = AnimationTweens.NONE;
tween_yy = AnimationTweens.NONE;
tween_zz = AnimationTweens.NONE;
tween_xrot = AnimationTweens.NONE;
tween_yrot = AnimationTweens.NONE;
tween_zrot = AnimationTweens.NONE;
tween_xscale = AnimationTweens.NONE;
tween_yscale = AnimationTweens.NONE;
tween_zscale = AnimationTweens.NONE;

tween_color = AnimationTweens.NONE;
tween_alpha = AnimationTweens.NONE;

moment = 0;

enum AnimationTweens {
    NONE,
    INSTANT,
    LINEAR,
    EASING
}