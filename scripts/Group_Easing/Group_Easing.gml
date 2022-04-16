function easing_get(type, t) {
    if (type == Easings.NONE) return 0;
    var curve = animcurve_get(ac_easings);
    if (is_string(type)) return animcurve_channel_evaluate(curve.channels[animcurve_get_channel_index(curve, type)], t);
    return animcurve_channel_evaluate(curve.channels[type], t);
}

function ease(val1, val2, f, type) {
    return easing_get(type, f) * (val2 - val1) + val1;
}

enum Easings {
    LINEAR,
    QUAD_I, QUAD_O, QUAD_IO,
    CUBE_I, CUBE_O, CUBE_IO,
    QUART_I, QUART_O, QUART_IO,
    EXP_I, EXP_O, EXP_IO,
    CIRC_I, CIRC_O, CIRC_IO,
    BACK_I, BACK_O, BACK_IO,
    ELASTIC_I, ELASTIC_O, ELASTIC_IO,
    BOUNCE_I, BOUNCE_O, BOUNCE_IO,
    FAST_TO_SLOW, MID_TO_SLOW,
    // added these later
    NONE
}

// just in case you want to attach strings to them
global.animation_tween_names = [
    "Linear",
    "Quadratic In", "Quadratic Out", "Quadratic In/Out",
    "Cubic In", "Cubic Out", "Cubic In/Out",
    "Quartic In", "Quartic Out", "Quartic In/Out",
    "Exponential In", "Exponential Out", "Exponential In/Out",
    "Circular In", "Circular Out", "Circular In/Out",
    "Back In", "Back Out", "There and Back Again",
    "Elastic In", "Elastic Out", "Elastic In/Out",
    "Bounce In", "Bounce Out", "Bounce In/Out",
    "Fast to Slow", "Mid to Slow",
];
