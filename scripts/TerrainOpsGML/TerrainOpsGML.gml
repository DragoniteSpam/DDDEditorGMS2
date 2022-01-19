function terrainops_to_heightmap(data, scale) {
    var output = buffer_create(buffer_get_size(data), buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_to_heightmap(buffer_get_address(data), buffer_get_address(output), buffer_get_size(data), scale);
    return output;
}

function terrainops_from_heightmap(data, scale) {
    var output = buffer_create(buffer_get_size(data), buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_from_heightmap(buffer_get_address(output), buffer_get_address(data), buffer_get_size(data), scale);
    return output;
}

function terrainops_generate(source, w, h) {
    var output = buffer_create(w * h * 18 * 4, buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_generate(buffer_get_address(source), buffer_get_address(output), w, h);
    return output;
}

function terrainops_mutate(height_data, noise_data, sprite_data, w, h, sprite_strength, noise_strength) {
    __terrainops_mutate_set_noise(buffer_get_address(noise_data), buffer_get_size(noise_data));
    __terrainops_mutate_set_texture(buffer_get_address(sprite_data), buffer_get_size(sprite_data));
    __terrainops_mutate_set_parameters(sprite_strength, noise_strength);
    __terrainops_mutate(buffer_get_address(height_data), w, h);
}

function terrainops_apply_scale(data, vertex_data, scale) {
    __terrainops_apply_scale(buffer_get_address(data), buffer_get_address(vertex_data), buffer_get_size(data), scale);
}

function terrainops_flatten(data, vertex_data, height) {
    __terrainops_flatten(buffer_get_address(data), buffer_get_address(vertex_data), buffer_get_size(data), height);
}

function terrainops_build(metadata, source, width, height, vertex_size, export_all, swap_zup, swap_uv, export_centered, density, save_scale) {
    __terrainops_build_settings(export_all, swap_zup, swap_uv, export_centered, density, width, height, save_scale);
    var bytes = __terrainops_build(buffer_get_address(source), buffer_get_address(metadata), buffer_get_size(source), buffer_get_size(metadata));
}

show_debug_message("TerrainOps version: " + terrainops_version());