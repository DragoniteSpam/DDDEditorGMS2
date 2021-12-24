function wireframe_enable(thickness = 1) {
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_Wireframe"), 1);
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_WireThickness"), thickness);
}

function wireframe_disable() {
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_Wireframe"), 0);
}