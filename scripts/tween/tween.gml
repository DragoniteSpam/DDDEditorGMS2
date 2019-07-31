/// @param v0
/// @param v1
/// @param f
/// @param tween-type

var v0 = argument0;
var v1 = argument1;
var f = argument2;
var type = argument3;

// big help: http://www.gizma.com/easing

switch (type) {
    case AnimationTweens.IGNORE:
    case AnimationTweens.NONE:
        return v0;
    case AnimationTweens.LINEAR:
        return lerp(v0, v1, f);
    // quadratic
    case AnimationTweens.EASE_QUAD_I:
        return ease_quad_i(v0, v1, f);
    case AnimationTweens.EASE_QUAD_O:
        return ease_quad_o(v0, v1, f);
    case AnimationTweens.EASE_QUAD_IO:
        return ease_quad_io(v0, v1, f);
    // cubic
    case AnimationTweens.EASE_CUBE_I:
        return ease_cube_i(v0, v1, f);
    case AnimationTweens.EASE_CUBE_O:
        return ease_cube_o(v0, v1, f);
    case AnimationTweens.EASE_CUBE_IO:
        return ease_cube_io(v0, v1, f);
    // quartic
    case AnimationTweens.EASE_QUART_I:
        return ease_quart_i(v0, v1, f);
    case AnimationTweens.EASE_QUART_O:
        return ease_quart_o(v0, v1, f);
    case AnimationTweens.EASE_QUART_IO:
        return ease_quart_io(v0, v1, f);
    // quintic
    case AnimationTweens.EASE_QUINT_I:
        return ease_quint_i(v0, v1, f);
    case AnimationTweens.EASE_QUINT_O:
        return ease_quint_o(v0, v1, f);
    case AnimationTweens.EASE_QUINT_IO:
        return ease_quint_io(v0, v1, f);
    // sine
    case AnimationTweens.EASE_SINE_I:
        return ease_sine_i(v0, v1, f);
    case AnimationTweens.EASE_SINE_O:
        return ease_sine_o(v0, v1, f);
    case AnimationTweens.EASE_SINE_IO:
        return ease_sine_io(v0, v1, f);
    // exponential
    case AnimationTweens.EASE_EXP_I:
        return ease_exp_i(v0, v1, f);
    case AnimationTweens.EASE_EXP_O:
        return ease_exp_o(v0, v1, f);
    case AnimationTweens.EASE_EXP_IO:
        return ease_exp_io(v0, v1, f);
    // circular
    case AnimationTweens.EASE_CIRC_I:
        return ease_circ_i(v0, v1, f);
    case AnimationTweens.EASE_CIRC_O:
        return ease_circ_o(v0, v1, f);
    case AnimationTweens.EASE_CIRC_IO:
        return ease_circ_io(v0, v1, f);
}