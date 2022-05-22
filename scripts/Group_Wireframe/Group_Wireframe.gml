function wireframe_enable(alpha = 1) {
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_WireAlpha"), alpha);
}

function wireframe_disable() {
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_WireAlpha"), 0);
}