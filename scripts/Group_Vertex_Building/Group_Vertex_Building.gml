function vertex_load(filename, format) {
    var buffer = buffer_load(filename);
    var vbuff = vertex_create_buffer_from_buffer(buffer, format);
    buffer_delete(buffer);
    return vbuff;
}

function vertex_point_complete(buffer, x, y, z, nx, ny, nz, xtex, ytex, color, alpha) {
    static bc_index = 0;
    
    vertex_position_3d(buffer, x, y, z);
    vertex_normal(buffer, nx, ny, nz);
    vertex_texcoord(buffer, xtex, ytex);
    vertex_colour(buffer, color, alpha);
    vertex_float3(buffer, 0, 0, 0);                                             // tangent
    vertex_float3(buffer, 0, 0, 0);                                             // bitangent
    vertex_float3(buffer, bc_index == 0, bc_index == 1, bc_index == 2);
    
    bc_index++;
    bc_index %= 3;
}

function vertex_point_complete_raw(buffer, x, y, z, nx, ny, nz, xtex, ytex, color, alpha) {
    static bc_index = 0;
    
    buffer_write(buffer, buffer_f32, x);
    buffer_write(buffer, buffer_f32, y);
    buffer_write(buffer, buffer_f32, z);
    buffer_write(buffer, buffer_f32, nx);
    buffer_write(buffer, buffer_f32, ny);
    buffer_write(buffer, buffer_f32, nz);
    buffer_write(buffer, buffer_f32, xtex);
    buffer_write(buffer, buffer_f32, ytex);
    buffer_write(buffer, buffer_u32, (floor(alpha * 0xff) << 24) | colour_reverse(color));
    // tangent
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 1);
    buffer_write(buffer, buffer_f32, 0);
    // bitangent
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 1);
    // barycentric
    buffer_write(buffer, buffer_f32, bc_index == 0);
    buffer_write(buffer, buffer_f32, bc_index == 1);
    buffer_write(buffer, buffer_f32, bc_index == 2);
    
    bc_index = ++bc_index % 3;
}

function vertex_to_reflect_buffer(buffer) {
    var new_buffer = buffer_clone(buffer);
    
    var op_mirror_x = Settings.mesh.reflect_settings & MeshReflectionSettings.MIRROR_X;
    var op_mirror_y = Settings.mesh.reflect_settings & MeshReflectionSettings.MIRROR_Y;
    var op_mirror_z = Settings.mesh.reflect_settings & MeshReflectionSettings.MIRROR_Z;
    var op_rotate_x = Settings.mesh.reflect_settings & MeshReflectionSettings.ROTATE_X;
    var op_rotate_y = Settings.mesh.reflect_settings & MeshReflectionSettings.ROTATE_Y;
    var op_rotate_z = Settings.mesh.reflect_settings & MeshReflectionSettings.ROTATE_Z;
    var op_reverse = Settings.mesh.reflect_settings & MeshReflectionSettings.REVERSE;
    var op_colorize = Settings.mesh.reflect_settings & MeshReflectionSettings.COLORIZE;
    var op_color_amt = clamp((Settings.mesh.reflect_color >> 24) / 0xff, 0, 1);
    var op_color_value = Settings.mesh.reflect_color & 0xffffff;
    
    if (op_mirror_x) meshops_mirror_axis_x(buffer_get_address(new_buffer), buffer_get_size(new_buffer));
    if (op_mirror_y) meshops_mirror_axis_y(buffer_get_address(new_buffer), buffer_get_size(new_buffer));
    if (op_mirror_z) meshops_mirror_axis_z(buffer_get_address(new_buffer), buffer_get_size(new_buffer));
    
    var t = matrix_build_identity();
    if (op_rotate_x) t = matrix_multiply(t, matrix_build(0, 0, 0, 180, 0, 0, 1, 1, 1));
    if (op_rotate_y) t = matrix_multiply(t, matrix_build(0, 0, 0, 0, 180, 0, 1, 1, 1));
    if (op_rotate_z) t = matrix_multiply(t, matrix_build(0, 0, 0, 0, 0, 180, 1, 1, 1));
    
    // this is the most expensive part of the operation so don't do it unless
    // it would actually accomplish anything
    if (!matrix_is_identity(t)) {
        meshops_set_matrix_raw(t[0], t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12], t[13], t[14], t[15]);
        meshops_transform(buffer_get_address(new_buffer), buffer_get_size(new_buffer));
    }
    
    if (op_reverse) meshops_reverse(buffer_get_address(new_buffer), buffer_get_size(new_buffer));
    if (op_colorize) meshops_blend_color(buffer_get_address(new_buffer), buffer_get_size(new_buffer), op_color_value, op_color_amt);
    
    return new_buffer;
}

/// @param buffer the source data buffer
/// @param chunk_size this is exactly what you think it is
/// @param max_x the maximum horizontal number of chunks
/// @param max_y the maximum vertical number of chunks
/// @return a struct containing structs of { buffer, { x, y } }
function vertex_buffer_as_chunks(buffer, chunk_size, max_x, max_y) {
    buffer_seek(buffer, buffer_seek_start, 0);
    var record = { };
    
    for (var i = 0, n = buffer_get_size(buffer); i < n; i += VERTEX_SIZE * 3) {
        // position, normal, texture, colour
        var p1 =  { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 00, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 04, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 08, buffer_f32) };
        var n1 =  { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 12, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 16, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 20, buffer_f32) };
        var t1 =  { u: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 24, buffer_f32), v: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 28, buffer_f32) };
        var c1 =       buffer_peek(buffer, i + 0 * VERTEX_SIZE + 32, buffer_u32);
        // tangent, bitangent, barycentric
        var ta1 = { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 36, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 40, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 44, buffer_f32) };
        var bi1 = { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 48, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 52, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 56, buffer_f32) };
        var ba1 = { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 60, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 64, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 68, buffer_f32) };
        
        var p2 =  { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 00, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 04, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 08, buffer_f32) };
        var n2 =  { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 12, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 16, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 20, buffer_f32) };
        var t2 =  { u: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 24, buffer_f32), v: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 28, buffer_f32) };
        var c2 =       buffer_peek(buffer, i + 1 * VERTEX_SIZE + 32, buffer_u32);
        var ta2 = { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 36, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 40, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 44, buffer_f32) };
        var bi2 = { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 48, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 52, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 56, buffer_f32) };
        var ba2 = { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 60, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 64, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 68, buffer_f32) };
        
        var p3 =  { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 00, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 04, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 08, buffer_f32) };
        var n3 =  { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 12, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 16, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 20, buffer_f32) };
        var t3 =  { u: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 24, buffer_f32), v: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 28, buffer_f32) };
        var c3 =       buffer_peek(buffer, i + 2 * VERTEX_SIZE + 32, buffer_u32);
        var ta3 = { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 36, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 40, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 44, buffer_f32) };
        var bi3 = { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 48, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 52, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 56, buffer_f32) };
        var ba3 = { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 60, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 64, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 68, buffer_f32) };
        
        var chunk_id = new Vector2(min(max_x, p1.x div chunk_size), min(max_y, p1.y div chunk_size));
        var chunk_data = record[$ json_stringify(chunk_id)];
        
        if (!chunk_data) {
            chunk_data = { coords: chunk_id, buffer: buffer_create(1024, buffer_grow, 1) };
            record[$ json_stringify(chunk_id)] = chunk_data;
        }
        
        var buff = chunk_data.buffer;
        buffer_write(buff, buffer_f32, p1.x);
        buffer_write(buff, buffer_f32, p1.y);
        buffer_write(buff, buffer_f32, p1.z);
        buffer_write(buff, buffer_f32, n1.x);
        buffer_write(buff, buffer_f32, n1.y);
        buffer_write(buff, buffer_f32, n1.z);
        buffer_write(buff, buffer_f32, t1.u);
        buffer_write(buff, buffer_f32, t1.v);
        buffer_write(buff, buffer_u32, c1);
        
        buffer_write(buff, buffer_f32, ta1.x);
        buffer_write(buff, buffer_f32, ta1.y);
        buffer_write(buff, buffer_f32, ta1.z);
        buffer_write(buff, buffer_f32, bi1.x);
        buffer_write(buff, buffer_f32, bi1.y);
        buffer_write(buff, buffer_f32, bi1.z);
        buffer_write(buff, buffer_f32, ba1.x);
        buffer_write(buff, buffer_f32, ba1.y);
        buffer_write(buff, buffer_f32, ba1.z);
        //
        buffer_write(buff, buffer_f32, p2.x);
        buffer_write(buff, buffer_f32, p2.y);
        buffer_write(buff, buffer_f32, p2.z);
        buffer_write(buff, buffer_f32, n2.x);
        buffer_write(buff, buffer_f32, n2.y);
        buffer_write(buff, buffer_f32, n2.z);
        buffer_write(buff, buffer_f32, t2.u);
        buffer_write(buff, buffer_f32, t2.v);
        buffer_write(buff, buffer_u32, c2);
        
        buffer_write(buff, buffer_f32, ta2.x);
        buffer_write(buff, buffer_f32, ta2.y);
        buffer_write(buff, buffer_f32, ta2.z);
        buffer_write(buff, buffer_f32, bi2.x);
        buffer_write(buff, buffer_f32, bi2.y);
        buffer_write(buff, buffer_f32, bi2.z);
        buffer_write(buff, buffer_f32, ba2.x);
        buffer_write(buff, buffer_f32, ba2.y);
        buffer_write(buff, buffer_f32, ba2.z);
        //
        buffer_write(buff, buffer_f32, p3.x);
        buffer_write(buff, buffer_f32, p3.y);
        buffer_write(buff, buffer_f32, p3.z);
        buffer_write(buff, buffer_f32, n3.x);
        buffer_write(buff, buffer_f32, n3.y);
        buffer_write(buff, buffer_f32, n3.z);
        buffer_write(buff, buffer_f32, t3.u);
        buffer_write(buff, buffer_f32, t3.v);
        buffer_write(buff, buffer_u32, c3);
        
        buffer_write(buff, buffer_f32, ta3.x);
        buffer_write(buff, buffer_f32, ta3.y);
        buffer_write(buff, buffer_f32, ta3.z);
        buffer_write(buff, buffer_f32, bi3.x);
        buffer_write(buff, buffer_f32, bi3.y);
        buffer_write(buff, buffer_f32, bi3.z);
        buffer_write(buff, buffer_f32, ba3.x);
        buffer_write(buff, buffer_f32, ba3.y);
        buffer_write(buff, buffer_f32, ba3.z);
    }
    
    var keys = variable_struct_get_names(record);
    for (var i = 0, n = array_length(keys); i < n; i++) {
        var chunk = record[$ keys[i]];
        buffer_resize(chunk.buffer, buffer_tell(chunk.buffer));
    }
    
    return record;
}

// This is a utility function that I'm going to keep around - in case the
// default DDD vertex format ever changes (again), which I hope it doesn't need
// to, pass the data into this function to update it to the new format
function vertex_buffer_update(raw) {
    return;
};