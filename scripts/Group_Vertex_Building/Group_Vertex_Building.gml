function vertex_point_complete(buffer, x, y, z, nx, ny, nz, xtex, ytex, color, alpha) {
    vertex_position_3d(buffer, x, y, z);
    vertex_normal(buffer, nx, ny, nz);
    vertex_texcoord(buffer, xtex, ytex);
    vertex_colour(buffer, color, alpha);
}

function vertex_point_complete_raw(buffer, x, y, z, nx, ny, nz, xtex, ytex, color, alpha) {
    buffer_write(buffer, buffer_f32, x);
    buffer_write(buffer, buffer_f32, y);
    buffer_write(buffer, buffer_f32, z);
    buffer_write(buffer, buffer_f32, nx);
    buffer_write(buffer, buffer_f32, ny);
    buffer_write(buffer, buffer_f32, nz);
    buffer_write(buffer, buffer_f32, xtex);
    buffer_write(buffer, buffer_f32, ytex);
    buffer_write(buffer, buffer_u32, (floor(alpha * 0xff) << 24) | colour_reverse(color));
}

function vertex_point_line(buffer, x, y, z, color, alpha) {
    vertex_position_3d(buffer, x, y, z);
    vertex_normal(buffer, 0, 0, 1);
    vertex_texcoord(buffer, 0, 0);
    vertex_colour(buffer, color, alpha);
}

function vertex_point_line_raw(buffer, x, y, z, color, alpha) {
    buffer_write(buffer, buffer_f32, x);
    buffer_write(buffer, buffer_f32, y);
    buffer_write(buffer, buffer_f32, z);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 1);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_f32, 0);
    buffer_write(buffer, buffer_u32, (floor(alpha * 0xff) << 24) | colour_reverse(color));
}

function buffer_to_wireframe(buffer) {
    var wbuffer = -1;
    static fsize = buffer_sizeof(buffer_f32);
    
    try {
        wbuffer = vertex_create_buffer();
        vertex_begin(wbuffer, Stuff.graphics.vertex_format);
        for (var i = 0; i < buffer_get_size(buffer); i += VERTEX_SIZE * 3) {
            var x1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 0 * fsize, buffer_f32);
            var y1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 1 * fsize, buffer_f32);
            var z1 = buffer_peek(buffer, i + 0 * VERTEX_SIZE + 2 * fsize, buffer_f32);
            var x2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 0 * fsize, buffer_f32);
            var y2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 1 * fsize, buffer_f32);
            var z2 = buffer_peek(buffer, i + 1 * VERTEX_SIZE + 2 * fsize, buffer_f32);
            var x3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 0 * fsize, buffer_f32);
            var y3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 1 * fsize, buffer_f32);
            var z3 = buffer_peek(buffer, i + 2 * VERTEX_SIZE + 2 * fsize, buffer_f32);
            vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
            vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
            vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
            vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
            vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
            vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        }
        vertex_end(wbuffer);
    } catch (e) {
        if (wbuffer) vertex_delete_buffer(wbuffer);
        wbuffer = -1;
    }
    
    return wbuffer;
}

function buffer_to_reflect(buffer) {
    var rbuffer = -1;
    static fsize = buffer_sizeof(buffer_f32);
    
    try {
        rbuffer = vertex_create_buffer();
        vertex_begin(rbuffer, Stuff.graphics.vertex_format);
        var op_mirror_x = Stuff.mesh_ed.reflect_settings & MeshReflectionSettings.MIRROR_X;
        var op_mirror_y = Stuff.mesh_ed.reflect_settings & MeshReflectionSettings.MIRROR_Y;
        var op_mirror_z = Stuff.mesh_ed.reflect_settings & MeshReflectionSettings.MIRROR_Z;
        var op_rotate_x = Stuff.mesh_ed.reflect_settings & MeshReflectionSettings.ROTATE_X;
        var op_rotate_y = Stuff.mesh_ed.reflect_settings & MeshReflectionSettings.ROTATE_Y;
        var op_rotate_z = Stuff.mesh_ed.reflect_settings & MeshReflectionSettings.ROTATE_Z;
        var op_reverse = Stuff.mesh_ed.reflect_settings & MeshReflectionSettings.REVERSE;
        var op_colorize = Stuff.mesh_ed.reflect_settings & MeshReflectionSettings.COLORIZE;
        var op_color_amt = clamp((Stuff.mesh_ed.reflect_color >> 24) / 0xff, 0, 1);
        var op_color_value = Stuff.mesh_ed.reflect_color & 0xffffff;
        
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

function vertex_buffer_to_wireframe(vbuffer) {
    var buffer = -1;
    var wbuffer = -1;
    static fsize = buffer_sizeof(buffer_f32);
    
    try {
        buffer = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 4);
        wbuffer = buffer_to_wireframe(buffer);
    } catch (e) {
        if (wbuffer) vertex_delete_buffer(wbuffer);
        wbuffer = -1;
    } finally {
        if (buffer) buffer_delete(buffer);
    }
    
    return wbuffer;
}