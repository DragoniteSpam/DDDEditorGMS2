function terrainops_to_heightmap(data) {
    var output = buffer_create(buffer_get_size(data), buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_to_heightmap(buffer_get_address(output));
    return output;
}

function terrainops_from_heightmap(data, scale, w, h) {
    var output = buffer_create(buffer_get_size(data), buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    terrainops_set_active_data(buffer_get_address(output), w, h);
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

function terrainops_generate_lod_internal(source, w, h) {
    var output = buffer_create(w * h * 18 * 4 / TERRAIN_INTERNAL_LOD_REDUCTION, buffer_fixed, 1);
    buffer_poke(output, 0, buffer_u32, 0);
    buffer_poke(output, buffer_get_size(output) - 4, buffer_u32, 0);
    __terrainops_generate_lod_internal(buffer_get_address(output));
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

function TERRAINOPS_BUILD_D3D(raw, length, out) {
    return __terrainops_build_d3d(buffer_get_address(raw), length, buffer_get_address(out));
}

function TERRAINOPS_BUILD_OBJ(raw, length, out) {
    return __terrainops_build_obj(buffer_get_address(raw), length, buffer_get_address(out));
}

function TERRAINOPS_BUILD_VBUFF(raw, length, out) {
    return __terrainops_build_vbuff(buffer_get_address(raw), length, buffer_get_address(out));
}

function TERRAINOPS_BUILD_INTERNAL(out) {
    return __terrainops_build_internal(buffer_get_address(out));
}

function terrainops_build_file(filename, reprocessor_function, chunk_size, export_all, swap_zup, swap_uv, export_centered, density, save_scale, sprite, format, water_level, smooth_normals) {
    // we'll estimate a max of 144 characters per line, plus a kilobyte overhead
    static raw_output = buffer_create(1024, buffer_fixed, 1);
    static reprocessed = buffer_create(1024, buffer_fixed, 1);
    
    var w = Stuff.terrain.width;
    var h = Stuff.terrain.height;
    if (chunk_size == 0) chunk_size = min(1024, max(w, h));
    buffer_resize(raw_output, max(buffer_get_size(raw_output), 1024 + 144 * 6 * chunk_size * chunk_size));
    buffer_poke(raw_output, 0, buffer_u32, 0);
    buffer_poke(raw_output, buffer_get_size(raw_output) - 4, buffer_u32, 0);
    buffer_resize(reprocessed, max(buffer_get_size(reprocessed), 1024 + 144 * 6 * chunk_size * chunk_size));
    buffer_poke(reprocessed, 0, buffer_u32, 0);
    buffer_poke(reprocessed, buffer_get_size(reprocessed) - 4, buffer_u32, 0);
    
    var fn = filename_change_ext(filename, "");
    var ext = filename_ext(filename);
    var texture_buffer = Stuff.terrain.texture.GetBuffer();
    var colour_buffer = Stuff.terrain.color.GetBuffer();
    
    var cscalemin = min(Stuff.terrain.color.width / w, Stuff.terrain.color.height / h);
    
    __terrainops_build_settings(export_all, swap_zup, swap_uv, export_centered, density, save_scale, (Settings.terrain.tile_brush_size - 1) / sprite_get_width(Stuff.terrain.texture_image), cscalemin, format, water_level, smooth_normals);
    __terrainops_build_texture(buffer_get_address(texture_buffer));
    __terrainops_build_vertex_colour(buffer_get_address(colour_buffer));
    
    var results = (reprocessor_function == TERRAINOPS_BUILD_INTERNAL) ? [] : undefined;
    
    for (var i = 0; i < w ; i += chunk_size) {
        for (var j = 0; j < h; j += chunk_size) {
            __terrainops_build_bounds(i, j, i + chunk_size, j + chunk_size);
            var raw_bytes = TERRAINOPS_BUILD_INTERNAL(raw_output);
            var key = string(i div chunk_size) + "_" + string(j div chunk_size);
            
            // if you're going to add it to the project, don't re-process the raw data
            if (reprocessor_function == TERRAINOPS_BUILD_INTERNAL) {
                var data = {
                    x: i,
                    y: j,
                    name: "Chunk " + key,
                    buffer: buffer_create(raw_bytes, buffer_fixed, 1),
                };
                array_push(results, data);
                buffer_copy(raw_output, 0, raw_bytes, data.buffer, 0);
            // otherwise, take the raw data (containing the correct normals,
            // alignment, etc) and reprocess it into a d3d, obj, etc
            } else {
                var reprocessed_bytes = reprocessor_function(reprocessed, raw_bytes, raw_output);
                var output_name = fn + ((chunk_size < w || chunk_size < h) ? ("." + key + ext) : ext);
                buffer_save_async(reprocessed, output_name, 0, reprocessed_bytes);
            }
        }
    }
    
    buffer_delete(texture_buffer);
    buffer_delete(colour_buffer);
    
    sprite_save(sprite, 0, filename_path(filename) + "terrain.png");
    
    return results;
}

function terrainops_build_mtl(filename) {
    static output = buffer_create(1024, buffer_fixed, 1);
    buffer_seek(output, buffer_seek_start, 0);
    buffer_write(output, buffer_text, "newmtl terrain\r\nKd 1.000 1.000 1.000\r\nmap_Kd terrain.png");
    buffer_save_async(output, filename_path(filename) + "terrain.mtl", 0, buffer_tell(output));
}

show_debug_message("TerrainOps version: " + terrainops_version());