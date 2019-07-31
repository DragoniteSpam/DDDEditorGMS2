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

tween_xx = AnimationTweens.EASE_EXP_O;
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
    // i MAY add an option to disable keyframes for properties entirely at some point (but probably not)
    // but for now this is just going to just be the same as "none"
    IGNORE,
    NONE,
    LINEAR,
    EASE_QUAD_I,
    EASE_QUAD_O,
    EASE_QUAD_IO,
    EASE_SINE_I,
    EASE_SINE_O,
    EASE_SINE_IO,
    EASE_CUBE_I,
    EASE_CUBE_O,
    EASE_CUBE_IO,
    EASE_QUART_I,
    EASE_QUART_O,
    EASE_QUART_IO,
    EASE_QUINT_I,
    EASE_QUINT_O,
    EASE_QUINT_IO,
    EASE_EXP_I,
    EASE_EXP_O,
    EASE_EXP_IO,
    EASE_CIRC_I,
    EASE_CIRC_O,
    EASE_CIRC_IO,
}