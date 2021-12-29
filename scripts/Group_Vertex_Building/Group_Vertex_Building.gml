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
    
    bc_index = ++bc_index % 3;
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
    buffer_write(buffer, buffer_f32, 2);
    // bitangent
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 1);
    buffer_write(buffer, buffer_f32, 2);
    // barycentric
    buffer_write(buffer, buffer_f32, bc_index == 0);
    buffer_write(buffer, buffer_f32, bc_index == 1);
    buffer_write(buffer, buffer_f32, bc_index == 2);
    
    bc_index = ++bc_index % 3;
}

function vertex_to_reflect(buffer) {
    var rbuffer = -1;
    static fsize = buffer_sizeof(buffer_f32);
    
    try {
        rbuffer = vertex_create_buffer();
        vertex_begin(rbuffer, Stuff.graphics.vertex_format);
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
        
        var transform_matrix = matrix_build_identity();
        if (op_mirror_x) transform_matrix = matrix_multiply(transform_matrix, matrix_build(0, 0, 0, 0, 0, 0, -1, 1, 1));
        if (op_mirror_y) transform_matrix = matrix_multiply(transform_matrix, matrix_build(0, 0, 0, 0, 0, 0, 1, -1, 1));
        if (op_mirror_z) transform_matrix = matrix_multiply(transform_matrix, matrix_build(0, 0, 0, 0, 0, 0, 1, 1, -1));
        if (op_rotate_x) transform_matrix = matrix_multiply(transform_matrix, matrix_build(0, 0, 0, 180, 0, 0, 1, 1, 1));
        if (op_rotate_y) transform_matrix = matrix_multiply(transform_matrix, matrix_build(0, 0, 0, 0, 180, 0, 1, 1, 1));
        if (op_rotate_z) transform_matrix = matrix_multiply(transform_matrix, matrix_build(0, 0, 0, 0, 0, 180, 1, 1, 1));
        
        for (var i = 0; i < buffer_get_size(buffer); i += VERTEX_SIZE * 3) {
            var x1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 0 * fsize, buffer_f32);
            var y1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 1 * fsize, buffer_f32);
            var z1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 2 * fsize, buffer_f32);
            var nx1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 3 * fsize, buffer_f32);
            var ny1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 4 * fsize, buffer_f32);
            var nz1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 5 * fsize, buffer_f32);
            var u1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 6 * fsize, buffer_f32);
            var v1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 7 * fsize, buffer_f32);
            var c1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 8 * fsize, buffer_u32);
            var a1 = (c1 >> 24) / 0xff;
            c1 &= 0xffffff;
            
            var x2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 0 * fsize, buffer_f32);
            var y2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 1 * fsize, buffer_f32);
            var z2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 2 * fsize, buffer_f32);
            var nx2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 3 * fsize, buffer_f32);
            var ny2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 4 * fsize, buffer_f32);
            var nz2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 5 * fsize, buffer_f32);
            var u2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 6 * fsize, buffer_f32);
            var v2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 7 * fsize, buffer_f32);
            var c2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 8 * fsize, buffer_u32);
            var a2 = (c2 >> 24) / 0xff;
            c2 &= 0xffffff;
            
            var x3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 0 * fsize, buffer_f32);
            var y3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 1 * fsize, buffer_f32);
            var z3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 2 * fsize, buffer_f32);
            var nx3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 3 * fsize, buffer_f32);
            var ny3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 4 * fsize, buffer_f32);
            var nz3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 5 * fsize, buffer_f32);
            var u3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 6 * fsize, buffer_f32);
            var v3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 7 * fsize, buffer_f32);
            var c3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 8 * fsize, buffer_u32);
            var a3 = (c3 >> 24) / 0xff;
            c3 &= 0xffffff;
            
            if (op_reverse) {
                var t = x3; x3 = x2; x2 = t;
                t = y3; y3 = y2; y2 = t;
                t = z3; z3 = z2; z2 = t;
                t = nx3; nx3 = nx2; nx2 = t;
                t = ny3; ny3 = ny2; ny2 = t;
                t = nz3; nz3 = nz2; nz2 = t;
                t = u3; u3 = u2; u2 = t;
                t = v3; v3 = v2; v2 = t;
                t = c3; c3 = c2; c2 = t;
                t = a3; a3 = a2; a2 = t;
            }
            
            if (op_colorize) {
                c1 = merge_colour(c1, op_color_value, op_color_amt);
                c2 = merge_colour(c2, op_color_value, op_color_amt);
                c3 = merge_colour(c3, op_color_value, op_color_amt);
            }
            
            var new_p1 = matrix_transform_vertex(transform_matrix, x1, y1, z1);
            var new_p2 = matrix_transform_vertex(transform_matrix, x2, y2, z2);
            var new_p3 = matrix_transform_vertex(transform_matrix, x3, y3, z3);
            var new_n1 = matrix_transform_vertex(transform_matrix, nx1, ny1, nz1);
            var new_n2 = matrix_transform_vertex(transform_matrix, nx2, ny2, nz2);
            var new_n3 = matrix_transform_vertex(transform_matrix, nx3, ny3, nz3);
            
            vertex_point_complete(rbuffer, new_p1[0], new_p1[1], new_p1[2], new_n1[0], new_n1[1], new_n1[2], u1, v1, c1, a1);
            vertex_point_complete(rbuffer, new_p2[0], new_p2[1], new_p2[2], new_n2[0], new_n2[1], new_n2[2], u2, v2, c2, a2);
            vertex_point_complete(rbuffer, new_p3[0], new_p3[1], new_p3[2], new_n3[0], new_n3[1], new_n3[2], u3, v3, c3, a3);
        }
        vertex_end(rbuffer);
    } catch (e) {
        if (rbuffer) vertex_delete_buffer(rbuffer);
        rbuffer = -1;
    }
    
    return rbuffer;
}

function vertex_buffer_as_chunks(buffer, chunk_size, max_x, max_y) {
    buffer_seek(buffer, buffer_seek_start, 0);
    var record = { };
    
    for (var i = 0, n = buffer_get_size(buffer); i < n; i += VERTEX_SIZE * 3) {
        // position, normal, texture, colour
        var p1 = { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 00, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 04, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 08, buffer_f32) };
        var n1 = { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 12, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 16, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 20, buffer_f32) };
        var t1 = { u: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 24, buffer_f32), v: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 28, buffer_f32) };
        var c1 =      buffer_peek(buffer, i + 0 * VERTEX_SIZE + 32, buffer_u32);
        // tangent, bitangent, barycentric
        var ta1 = { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 36, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 40, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 44, buffer_f32) };
        var bi1 = { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 48, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 52, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 56, buffer_f32) };
        var ba1 = { x: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 60, buffer_f32), y: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 64, buffer_f32), z: buffer_peek(buffer, i + 0 * VERTEX_SIZE + 68, buffer_f32) };
        
        var p2 = { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 00, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 04, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 08, buffer_f32) };
        var n2 = { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 12, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 16, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 20, buffer_f32) };
        var t2 = { u: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 24, buffer_f32), v: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 28, buffer_f32) };
        var c2 =      buffer_peek(buffer, i + 1 * VERTEX_SIZE + 32, buffer_u32);
        var ta2 = { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 36, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 40, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 44, buffer_f32) };
        var bi2 = { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 48, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 52, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 56, buffer_f32) };
        var ba2 = { x: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 60, buffer_f32), y: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 64, buffer_f32), z: buffer_peek(buffer, i + 1 * VERTEX_SIZE + 68, buffer_f32) };
        
        var p3 = { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 00, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 04, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 08, buffer_f32) };
        var n3 = { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 12, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 16, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 20, buffer_f32) };
        var t3 = { u: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 24, buffer_f32), v: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 28, buffer_f32) };
        var c3 =      buffer_peek(buffer, i + 2 * VERTEX_SIZE + 32, buffer_u32);
        var ta3 = { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 36, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 40, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 44, buffer_f32) };
        var bi3 = { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 48, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 52, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 56, buffer_f32) };
        var ba3 = { x: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 60, buffer_f32), y: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 64, buffer_f32), z: buffer_peek(buffer, i + 2 * VERTEX_SIZE + 68, buffer_f32) };
        
        var chunk_id = { x: min(max_x, p1.x div (TILE_WIDTH * chunk_size)), y: min(max_y, p1.y div (TILE_HEIGHT * chunk_size)) };
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

function vertex_buffer_formatted(buffer, format) {
    var formatted_buffer = buffer_create(1, buffer_grow, 1);
    buffer_seek(buffer, buffer_seek_start, 0);
    var bc_index = 0;
    for (var i = 0; i < buffer_get_size(buffer); i += VERTEX_SIZE) {
        var xx = buffer_peek(buffer, i + 00, buffer_f32);
        var yy = buffer_peek(buffer, i + 04, buffer_f32);
        var zz = buffer_peek(buffer, i + 08, buffer_f32);
        var nx = buffer_peek(buffer, i + 12, buffer_f32);
        var ny = buffer_peek(buffer, i + 16, buffer_f32);
        var nz = buffer_peek(buffer, i + 20, buffer_f32);
        var xt = buffer_peek(buffer, i + 24, buffer_f32);
        var yt = buffer_peek(buffer, i + 28, buffer_f32);
        var cc = buffer_peek(buffer, i + 32, buffer_u32);
        if (format & (1 << VertexFormatData.POSITION_2D)) {
            buffer_write(formatted_buffer, buffer_f32, xx);
            buffer_write(formatted_buffer, buffer_f32, yy);
        }
        if (format & (1 << VertexFormatData.POSITION_3D)) {
            buffer_write(formatted_buffer, buffer_f32, xx);
            buffer_write(formatted_buffer, buffer_f32, yy);
            buffer_write(formatted_buffer, buffer_f32, zz);
        }
        if (format & (1 << VertexFormatData.NORMAL)) {
            buffer_write(formatted_buffer, buffer_f32, nx);
            buffer_write(formatted_buffer, buffer_f32, ny);
            buffer_write(formatted_buffer, buffer_f32, nz);
        }
        if (format & (1 << VertexFormatData.TEXCOORD)) {
            buffer_write(formatted_buffer, buffer_f32, xt);
            buffer_write(formatted_buffer, buffer_f32, yt);
        }
        if (format & (1 << VertexFormatData.COLOUR)) {
            buffer_write(formatted_buffer, buffer_u32, cc);
        }
        if (format & (1 << VertexFormatData.TANGENT)) {
            
        }
        if (format & (1 << VertexFormatData.BITANGENT)) {
            
        }
        if (format & (1 << VertexFormatData.BARYCENTRIC)) {
            buffer_write(formatted_buffer, buffer_f32, (bc_index == 0));
            buffer_write(formatted_buffer, buffer_f32, (bc_index == 1));
            buffer_write(formatted_buffer, buffer_f32, (bc_index == 2));
        }
        if (format & (1 << VertexFormatData.SMALL_NORMAL)) {
            
        }
        if (format & (1 << VertexFormatData.SMALL_TANGENT)) {
            
        }
        if (format & (1 << VertexFormatData.SMALL_BITANGENT)) {
            
        }
        if (format & (1 << VertexFormatData.SMALL_TEXCOORD)) {
            
        }
        if (format & (1 << VertexFormatData.SMALL_NORMAL_PLUS_TEXCOORD)) {
            
        }
        bc_index = ++bc_index % 3;
    }
    
    buffer_resize(formatted_buffer, buffer_tell(formatted_buffer));
    return formatted_buffer;
}

// This is a utility function that I'm going to keep around - in case the
// default DDD vertex format ever changes (again), which I hope it doesn't need
// to, pass the data into this function to update it to the new format
function vertex_buffer_update(raw) {
    return;
};