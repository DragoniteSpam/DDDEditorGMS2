function banding_enable(bands) {
    // not all shaders supporting banding may need to implement all of thsee,
    // but they'll all take this general form
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_Bands"), bands);
}

function banding_disable() {
    shader_set_uniform_f(shader_get_uniform(shader_current(), "u_Bands"), 255);
}