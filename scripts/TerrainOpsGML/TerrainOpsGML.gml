function terrainops_to_heightmap(data, scale) {
    var output = buffer_create(buffer_get_size(data), buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_to_heightmap(buffer_get_address(output), scale);
    return output;
}

function terrainops_from_heightmap(data, scale) {
    var output = buffer_create(buffer_get_size(data), buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_from_heightmap(buffer_get_address(data), scale);
    return output;
}

function terrainops_generate_internal(source, w, h) {
    var output = buffer_create(w * h * 18 * 4, buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_generate_internal(buffer_get_address(output));
    return output;
}

function terrainops_deform_settings(brush, index, x, y, radius, velocity) {
    var sprite_data = sprite_sample_get_buffer(brush, index);
    __terrainops_deform_brush(buffer_get_address(sprite_data), sprite_get_width(brush), sprite_get_height(brush));
    __terrainops_deform_brush_settings(radius, velocity);
    __terrainops_deform_brush_position(x, y);
}

function terrainops_mutate(height_data, vertex_data, w, h, noise_data, noise_w, noise_h, noise_strength, sprite_data, sprite_w, sprite_h, sprite_strength) {
    __terrainops_mutate_set_noise(buffer_get_address(noise_data), noise_w, noise_h, noise_strength);
    __terrainops_mutate_set_texture(buffer_get_address(sprite_data), sprite_w, sprite_h, sprite_strength);
    __terrainops_mutate();
}

function terrainops_apply_scale(data, vertex_data, scale) {
    __terrainops_apply_scale(scale);
}

function terrainops_flatten(data, vertex_data, height) {
    __terrainops_flatten(height);
}

function TERRAINOPS_BUILD_D3D(out) {
    return __terrainops_build_d3d(buffer_get_address(out));
}

function TERRAINOPS_BUILD_OBJ(out) {
    return __terrainops_build_obj(buffer_get_address(out));
}

function TERRAINOPS_BUILD_VBUFF(out) {
    return __terrainops_build_vbuff(buffer_get_address(out));
}

function terrainops_build_file(filename, builder_function, chunk_size, export_all, swap_zup, swap_uv, export_centered, density, save_scale, format = VertexFormatData.POSITION_3D | VertexFormatData.NORMAL | VertexFormatData.TEXCOORD | VertexFormatData.COLOUR) {
    // we'll estimate a max of 144 characters per line, plus a kilobyte overhead
    static output = buffer_create(1024, buffer_fixed, 1);
    buffer_resize(output, max(buffer_get_size(output), 1024 + 144 * 6 * chunk_size * chunk_size));
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    
    var w = Stuff.terrain.width;
    var h = Stuff.terrain.height;
    var fn = filename_change_ext(filename, "");
    var ext = filename_ext(filename);
    var texture_buffer = Stuff.terrain.texture.GetBuffer();
    var colour_buffer = Stuff.terrain.color.GetBuffer();
    
    __terrainops_build_settings(export_all, swap_zup, swap_uv, export_centered, density, save_scale, Settings.terrain.tile_brush_size / sprite_get_width(Stuff.terrain.texture_image), format);
    __terrainops_build_texture(buffer_get_address(texture_buffer));
    __terrainops_build_vertex_colour(buffer_get_address(colour_buffer));
    
    for (var i = 0; i < w ; i += chunk_size) {
        for (var j = 0; j < h; j += chunk_size) {
            __terrainops_build_bounds(i, j, i + chunk_size, j + chunk_size);
            var bytes = builder_function(output);
            buffer_save_ext(output, fn + ((chunk_size < w || chunk_size < h) ? ("." + string(i div chunk_size) + "_" + string(j div chunk_size) + ext) : ""), 0, bytes);
        }
    }
    
    buffer_delete(texture_buffer);
    buffer_delete(colour_buffer);
}

show_debug_message("TerrainOps version: " + terrainops_version());