function wireframe_enable() {
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_Wireframe"), 1);
}

function wireframe_disable() {
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_Wireframe"), 0);
}