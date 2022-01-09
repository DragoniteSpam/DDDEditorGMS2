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
    __terrainops_from_heightmap(buffer_get_address(output), buffer_get_address(data), min(buffer_get_size(data), buffer_get_size(data)), scale);
    return output;
}

function terrainops_generate(source, w, h) {
    var output = buffer_create((w + 1) * (h + 1) * 18 * 4, buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_generate(buffer_get_address(source), buffer_get_address(output), w, h);
    return output;
}

function terrainops_build(source, width, height, vertex_size, export_all, swap_zup, swap_uv, export_centered, density, save_scale) {
    var output = buffer_create(width * height * 6 * vertex_size, buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_build_settings(export_all, swap_zup, swap_uv, export_centered, density, width, height, save_scale);
    var bytes = __terrainops_build(buffer_get_address(source), buffer_get_address(output), buffer_get_size(source));
    buffer_resize(output, bytes);
    return output;
}

show_debug_message("TerrainOps version: " + terrainops_version());