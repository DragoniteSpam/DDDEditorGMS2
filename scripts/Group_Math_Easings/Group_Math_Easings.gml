function ease_circ_io(value0, value1, f) {
    // ease circular in and out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f * 2;
    var b = value0;
    var c = value1 - value0;
    if (t < 1) return -c / 2 * (sqrt(1 - t * t) - 1) + b;
    t = t - 2;
    return c / 2 * (sqrt(1 - t * t) + 1) + b;
};

function ease_circ_o(value0, value1, f) {
    // ease circular out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f - 1;
    var b = value0;
    var c = value1 - value0;
    return c * sqrt(1 - t * t) + b;
};

function ease_cube_i(value0, value1, f) {
    // ease cubic in
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return c * t * t * t + b;
};

function ease_cube_io(value0, value1, f) {
    // ease cubic in and out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f * 2;
    var b = value0;
    var c = value1 - value0;
    if (t < 1) return c / 2 * t * t * t + b;
    t = t - 2;
    return c / 2 * (t * t * t + 2) + b;
};

function ease_cube_o(value0, value1, f) {
    // ease cubic out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f - 1;
    var b = value0;
    var c = value1 - value0;
    return c * (t * t * t + 1) + b;
};

function ease_exp_i(value0, value1, f) {
    // ease exponential in
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return c * power(2, 10 * (t - 1)) + b;
};

function ease_exp_io(value0, value1, f) {
    // ease exponential in and out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f * 2;
    var b = value0;
    var c = value1 - value0;
    if (t < 1) return c / 2 * power(2, 10 * (t - 1)) + b;
    t--;
    return c / 2 * (-power(2, -10 * t) + 2) + b;
};

function ease_exp_o(value0, value1, f) {
    // ease exponential out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return c * (-power(2, -10 * t) + 1) + b;
};

function ease_linear(value0, value1, f) {
    // ease linear - just a wrapper for lerp
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return lerp(b, b + c, t);
};

function ease_none(value0, value1, f) {
    // does not do any sort of easing; just returns the first value
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return b;
};

function ease_quad_i(value0, value1, f) {
    // ease quadratic in
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return c * t * t + b;
};

function ease_quad_io(value0, value1, f) {
    // ease quadratic in and out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f * 2;
    var b = value0;
    var c = value1 - value0;
    if (t < 1) return c / 2 * t * t + b;
    t--;
    return -c / 2 * (t * (t - 2) - 1) + b;
};

function ease_quad_o(value0, value1, f) {
    // ease quadratic out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return -c * t * (t - 2) + b;
};

function ease_quart_i(value0, value1, f) {
    // ease quartic in
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return c * t * t * t * t + b;
};

function ease_quart_io(value0, value1, f) {
    // ease quartic in and out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f * 2;
    var b = value0;
    var c = value1 - value0;
    if (t < 1) return c / 2 * t * t * t * t + b;
    t = t - 2;
    return -c / 2 * (t * t * t * t - 2) + b;
};

function ease_quart_o(value0, value1, f) {
    // ease quartic out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f - 1;
    var b = value0;
    var c = value1 - value0;
    return c * (t * t * t * t - 1) + b;
};

function ease_quint_i(value0, value1, f) {
    // ease quintic in
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return c * t * t * t * t * t + b;
};

function ease_quint_io(value0, value1, f) {
    // ease quintic in and out
    // if you want to raise this to higher powers - sex, sept, oct, etc -
    // i assume it would just follow the same patterns as quad cube quart quint,
    // although i have no idea why you would need to ease anything past quintic
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f * 2;
    var b = value0;
    var c = value1 - value0;
    if (t < 1) return c / 2 * t * t * t * t * t + b;
    t = t - 2;
    return -c / 2 * (t * t * t * t * t - 2) + b;
};

function ease_quint_o(value0, value1, f) {
    // ease quintic out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f - 1;
    var b = value0;
    var c = value1 - value0;
    return c * (t * t * t * t * t - 1) + b;
};

function ease_sine_i(value0, value1, f) {
    // ease (co)sine in
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return -c * cos(t * (pi / 2)) + c + b;
};

function ease_sine_io(value0, value1, f) {
    // ease (co)sine in and out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return -c / 2 * (cos(pi * t) - 1) + b;
};

function ease_sine_o(value0, value1, f) {
    // ease (co)sine out
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return c * sin(t * (pi / 2)) + b;
};

function ease_circ_i(value0, value1, f) {
    // ease circular in
    // weird arguments but they match the format used by http://www.gizma.com/easing
    var t = f;
    var b = value0;
    var c = value1 - value0;
    return -c * (sqrt(1 - t * t) - 1) + b;
};