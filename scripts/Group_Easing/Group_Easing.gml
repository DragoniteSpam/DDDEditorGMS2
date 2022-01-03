function easing_get(type, t) {
    /// @todo
    if (code_is_compiled()) {
        show_debug_message("The YYC mangles the values inside this struct for some reason and it causes problems for all involved so I'm just going to have it return 0 for now");
        return 0;
    }
    if (type == AnimationTweens.IGNORE || type == AnimationTweens.NONE) return 0;
    return animcurve_channel_evaluate(animcurve_get(ac_easings).channels[type - 2], t);
}

function easing_tween(value_start, value_end, f, type) {
    return easing_get(type, f) * (value_end - value_start) + value_start;
};

enum AnimationTweens {
    // i MAY add an option to disable keyframes for properties entirely at some point (but probably not)
    // but for now this is just going to just be the same as "none"
    IGNORE, NONE, LINEAR,
    EASE_QUAD_I, EASE_QUAD_O, EASE_QUAD_IO,
    EASE_CUBE_I, EASE_CUBE_O, EASE_CUBE_IO,
    EASE_QUART_I, EASE_QUART_O, EASE_QUART_IO,
    EASE_EXP_I, EASE_EXP_O, EASE_EXP_IO,
    EASE_CIRC_I, EASE_CIRC_O, EASE_CIRC_IO,
    EASE_BACK_I, EASE_BACK_O, EASE_BACK_IO,
    EASE_ELASTIC_I, EASE_ELASTIC_O, EASE_ELASTIC_IO,
    EASE_BOUNCE_I, EASE_BOUNCE_O, EASE_BOUNCE_IO,
    EASE_FAST_TO_SLOW, EASE_MID_TO_SLOW,
}