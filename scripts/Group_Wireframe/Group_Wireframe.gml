function wireframe_enable(alpha = 1, distance = 128, color = c_white, thickness = 1) {
    // not all shaders supporting wireframes may need to implement all of thsee,
    // but they'll all take this general form
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_WireAlpha"), alpha);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_WireDistance"), distance);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_WireColor"), (color & 0x0000ff) / 0xff, ((color & 0x00ff00) >> 8) / 0xff, ((color & 0xff0000) >> 16) / 0xff);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_WireThickness"), thickness);
}

function wireframe_disable() {
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_WireAlpha"), 0);
}