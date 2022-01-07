function terrainops_to_heightmap(data, scale) {
    var output = buffer_create(buffer_get_size(data), buffer_fixed, 1);
    __terrainops_to_heightmap(buffer_get_address(data), buffer_get_address(output), buffer_get_size(data), scale);
    return output;
}

function terrainops_from_heightmap(data, source, scale) {
    __terrainops_from_heightmap(buffer_get_address(data), buffer_get_address(source), min(buffer_get_size(data), buffer_get_size(source)), scale);
}