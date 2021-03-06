function mesh_mirror_all_x(mesh) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_mirror_x(mesh, i);
    }
}

function mesh_mirror_all_y(mesh) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_mirror_y(mesh, i);
    }
}

function mesh_mirror_all_z(mesh) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_mirror_z(mesh, i);
    }
}

function mesh_mirror_x(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[| index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        buffer_poke(buffer, position, buffer_f32, -buffer_peek(buffer, position, buffer_f32));
        buffer_poke(buffer, position + 12, buffer_f32, -buffer_peek(buffer, position + 12, buffer_f32));
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    vertex_delete_buffer(submesh.wbuffer);
    var wbuffer = vertex_create_buffer();
    submesh.wbuffer = wbuffer;
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var x1 = buffer_read(buffer, buffer_f32);
        var y1 = buffer_read(buffer, buffer_f32);
        var z1 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x2 = buffer_read(buffer, buffer_f32);
        var y2 = buffer_read(buffer, buffer_f32);
        var z2 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x3 = buffer_read(buffer, buffer_f32);
        var y3 = buffer_read(buffer, buffer_f32);
        var z3 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    }
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
}

function mesh_mirror_y(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[| index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        buffer_poke(buffer, position + 4, buffer_f32, -buffer_peek(buffer, position + 4, buffer_f32));
        buffer_poke(buffer, position + 16, buffer_f32, -buffer_peek(buffer, position + 16, buffer_f32));
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    vertex_delete_buffer(submesh.wbuffer);
    var wbuffer = vertex_create_buffer();
    submesh.wbuffer = wbuffer;
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var x1 = buffer_read(buffer, buffer_f32);
        var y1 = buffer_read(buffer, buffer_f32);
        var z1 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x2 = buffer_read(buffer, buffer_f32);
        var y2 = buffer_read(buffer, buffer_f32);
        var z2 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x3 = buffer_read(buffer, buffer_f32);
        var y3 = buffer_read(buffer, buffer_f32);
        var z3 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    }
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
}

function mesh_mirror_z(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[| index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        buffer_poke(buffer, position + 8, buffer_f32, -buffer_peek(buffer, position + 8, buffer_f32));
        buffer_poke(buffer, position + 20, buffer_f32, -buffer_peek(buffer, position + 20, buffer_f32));
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    vertex_delete_buffer(submesh.wbuffer);
    var wbuffer = vertex_create_buffer();
    submesh.wbuffer = wbuffer;
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var x1 = buffer_read(buffer, buffer_f32);
        var y1 = buffer_read(buffer, buffer_f32);
        var z1 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x2 = buffer_read(buffer, buffer_f32);
        var y2 = buffer_read(buffer, buffer_f32);
        var z2 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x3 = buffer_read(buffer, buffer_f32);
        var y3 = buffer_read(buffer, buffer_f32);
        var z3 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    }
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
}

function mesh_rotate_all_up_axis(mesh) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_rotate_up_axis(mesh, i);
    }
}

function mesh_rotate_up_axis(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[| index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        var xx = buffer_peek(buffer, position, buffer_f32);
        var yy = buffer_peek(buffer, position + 4, buffer_f32);
        var zz = buffer_peek(buffer, position + 8, buffer_f32);
        var nx = buffer_peek(buffer, position + 12, buffer_f32);
        var ny = buffer_peek(buffer, position + 16, buffer_f32);
        var nz = buffer_peek(buffer, position + 20, buffer_f32);
        buffer_poke(buffer, position, buffer_f32, yy);
        buffer_poke(buffer, position + 4, buffer_f32, zz);
        buffer_poke(buffer, position + 8, buffer_f32, xx);
        buffer_poke(buffer, position + 12, buffer_f32, ny);
        buffer_poke(buffer, position + 16, buffer_f32, nz);
        buffer_poke(buffer, position + 20, buffer_f32, nx);
        
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    vertex_delete_buffer(submesh.wbuffer);
    var wbuffer = vertex_create_buffer();
    submesh.wbuffer = wbuffer;
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var x1 = buffer_read(buffer, buffer_f32);
        var y1 = buffer_read(buffer, buffer_f32);
        var z1 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x2 = buffer_read(buffer, buffer_f32);
        var y2 = buffer_read(buffer, buffer_f32);
        var z2 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x3 = buffer_read(buffer, buffer_f32);
        var y3 = buffer_read(buffer, buffer_f32);
        var z3 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    }
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
}

function mesh_set_all_flip_tex_h(mesh) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_set_flip_tex_h(mesh, i);
    }
}

function mesh_set_all_flip_tex_v(mesh) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_set_flip_tex_v(mesh, i);
    }
}

function mesh_set_all_scale(mesh, scale) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_set_scale(mesh, i, scale);
    }
}

function mesh_set_flip_tex_h(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[| index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        buffer_poke(buffer, position + 24, buffer_f32, 1 - buffer_peek(buffer, position + 24, buffer_f32));
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    vertex_delete_buffer(submesh.wbuffer);
    var wbuffer = vertex_create_buffer();
    submesh.wbuffer = wbuffer;
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var x1 = buffer_read(buffer, buffer_f32);
        var y1 = buffer_read(buffer, buffer_f32);
        var z1 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x2 = buffer_read(buffer, buffer_f32);
        var y2 = buffer_read(buffer, buffer_f32);
        var z2 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x3 = buffer_read(buffer, buffer_f32);
        var y3 = buffer_read(buffer, buffer_f32);
        var z3 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    }
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
}

function mesh_set_flip_tex_v(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[| index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        buffer_poke(buffer, position + 28, buffer_f32, 1 - buffer_peek(buffer, position + 28, buffer_f32));
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    vertex_delete_buffer(submesh.wbuffer);
    var wbuffer = vertex_create_buffer();
    submesh.wbuffer = wbuffer;
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var x1 = buffer_read(buffer, buffer_f32);
        var y1 = buffer_read(buffer, buffer_f32);
        var z1 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x2 = buffer_read(buffer, buffer_f32);
        var y2 = buffer_read(buffer, buffer_f32);
        var z2 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x3 = buffer_read(buffer, buffer_f32);
        var y3 = buffer_read(buffer, buffer_f32);
        var z3 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    }
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
}

function mesh_set_normals_flat(mesh) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[| i];
        var buffer = submesh.buffer;
        buffer_seek(buffer, buffer_seek_start, 0);
        
        while (buffer_tell(buffer) < buffer_get_size(buffer)) {
            var position = buffer_tell(buffer);
            
            var normals = triangle_normal(
                // t1
                buffer_peek(buffer, position, buffer_f32),
                buffer_peek(buffer, position + 4, buffer_f32),
                buffer_peek(buffer, position + 8, buffer_f32),
                // t2
                buffer_peek(buffer, position + VERTEX_SIZE, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 8, buffer_f32),
                // t3
                buffer_peek(buffer, position + VERTEX_SIZE * 2, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 8, buffer_f32),
            );
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 12, buffer_f32, normals[0]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 12, buffer_f32, normals[0]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 12, buffer_f32, normals[0]);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 16, buffer_f32, normals[1]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 16, buffer_f32, normals[1]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 16, buffer_f32, normals[1]);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 20, buffer_f32, normals[2]);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 20, buffer_f32, normals[2]);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 20, buffer_f32, normals[2]);
            
            buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE * 3);
        }
        
        buffer_seek(buffer, buffer_seek_start, 0);
        
        vertex_delete_buffer(submesh.vbuffer);
        submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
        vertex_freeze(submesh.vbuffer);
    }
}

function mesh_set_normals_smooth(mesh, threshold) {
    threshold = dcos(threshold);
    
    // probably not super efficient but
    if (threshold < 1) {
        mesh_set_normals_flat(mesh);
    }
    
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[| i];
        var buffer = submesh.buffer;
        buffer_seek(buffer, buffer_seek_start, 0);
        var normal_map = ds_map_create();
        
        while (buffer_tell(buffer) < buffer_get_size(buffer)) {
            var position = buffer_tell(buffer);
            
            var xx = [
                buffer_peek(buffer, position, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2, buffer_f32)
            ];
            var yy = [
                buffer_peek(buffer, position + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 4, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 4, buffer_f32)
            ];
            var zz = [
                buffer_peek(buffer, position + 8, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE + 8, buffer_f32),
                buffer_peek(buffer, position + VERTEX_SIZE * 2 + 8, buffer_f32)
            ];
            
            var normals = triangle_normal(xx[0], yy[0], zz[0], xx[1], yy[1], zz[1], xx[2], yy[2], zz[2]);
            
            for (var i = 0; i < 3; i++) {
                var key = string(xx[i]) + "," + string(yy[i]) + "," + string(zz[i]);
                if (ds_map_exists(normal_map, key)) {
                    var existing = normal_map[? key];
                    normal_map[? key] = [existing[0] + normals[0], existing[1] + normals[1], existing[2] + normals[2]];
                } else {
                    normal_map[? key] = normals;
                }
            }
            
            buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE * 3);
        }
        
        buffer_seek(buffer, buffer_seek_start, 0);
        
        while (buffer_tell(buffer) < buffer_get_size(buffer)) {
            var position = buffer_tell(buffer);
            
            var xx = buffer_peek(buffer, position, buffer_f32);
            var yy = buffer_peek(buffer, position + 4, buffer_f32);
            var zz = buffer_peek(buffer, position + 8, buffer_f32);
            var nx = buffer_peek(buffer, position + 12, buffer_f32);
            var ny = buffer_peek(buffer, position + 16, buffer_f32);
            var nz = buffer_peek(buffer, position + 20, buffer_f32);
            var key = string(xx) + "," + string(yy) + "," + string(zz);
            
            var n = vector3_normalize(normal_map[? key]);
            var angle_dot = dot_product_3d(n[0], n[1], n[2], nx, ny, nz);
            if (angle_dot > threshold) {
                buffer_poke(buffer, position + 12, buffer_f32, n[0]);
                buffer_poke(buffer, position + 16, buffer_f32, n[1]);
                buffer_poke(buffer, position + 20, buffer_f32, n[2]);
            }
            
            buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
        }
        
        ds_map_destroy(normal_map);
        vertex_delete_buffer(submesh.vbuffer);
        submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
        vertex_freeze(submesh.vbuffer);
    }
}

function mesh_set_normals_zero(mesh) {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[| i];
        var buffer = submesh.buffer;
        buffer_seek(buffer, buffer_seek_start, 0);
        
        while (buffer_tell(buffer) < buffer_get_size(buffer)) {
            var position = buffer_tell(buffer);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 12, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 12, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 12, buffer_f32, 1);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 16, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 16, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 16, buffer_f32, 1);
            
            buffer_poke(buffer, position + VERTEX_SIZE * 0 + 20, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 1 + 20, buffer_f32, 0);
            buffer_poke(buffer, position + VERTEX_SIZE * 2 + 20, buffer_f32, 1);
            
            buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE * 3);
        }
        
        buffer_seek(buffer, buffer_seek_start, 0);
        
        vertex_delete_buffer(submesh.vbuffer);
        submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
        vertex_freeze(submesh.vbuffer);
    }
}

function mesh_set_scale(mesh, index, scale) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[| index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        buffer_poke(buffer, position, buffer_f32, buffer_peek(buffer, position, buffer_f32) * scale);
        buffer_poke(buffer, position + 4, buffer_f32, buffer_peek(buffer, position + 4, buffer_f32) * scale);
        buffer_poke(buffer, position + 8, buffer_f32, buffer_peek(buffer, position + 8, buffer_f32) * scale);
        // if you scale uniformly, normals don't need to be scaled
        
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    vertex_delete_buffer(submesh.wbuffer);
    var wbuffer = vertex_create_buffer();
    submesh.wbuffer = wbuffer;
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var x1 = buffer_read(buffer, buffer_f32);
        var y1 = buffer_read(buffer, buffer_f32);
        var z1 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x2 = buffer_read(buffer, buffer_f32);
        var y2 = buffer_read(buffer, buffer_f32);
        var z2 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        var x3 = buffer_read(buffer, buffer_f32);
        var y3 = buffer_read(buffer, buffer_f32);
        var z3 = buffer_read(buffer, buffer_f32);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE - 12);
        
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        
        vertex_point_line(wbuffer, x2, y2, z2, c_white, 1);
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        
        vertex_point_line(wbuffer, x3, y3, z3, c_white, 1);
        vertex_point_line(wbuffer, x1, y1, z1, c_white, 1);
    }
    vertex_end(wbuffer);
    vertex_freeze(wbuffer);
}