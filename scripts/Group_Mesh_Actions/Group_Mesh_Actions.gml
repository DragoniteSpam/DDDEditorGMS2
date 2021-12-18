function mesh_mirror_all_x(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_mirror_x(mesh, i);
    }
}

function mesh_mirror_all_y(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_mirror_y(mesh, i);
    }
}

function mesh_mirror_all_z(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_mirror_z(mesh, i);
    }
}

function mesh_mirror_x(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
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
}

function mesh_mirror_y(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
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
}

function mesh_mirror_z(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
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
}

function mesh_rotate_all_up_axis(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_rotate_up_axis(mesh, i);
    }
}

function mesh_rotate_up_axis(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
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
}

function mesh_all_invert_alpha(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_invert_alpha(mesh, i);
    }
}

function mesh_invert_alpha(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        buffer_poke(buffer, position + 35, buffer_u8, 255 - buffer_peek(buffer, position + 35, buffer_u8));
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
}

function mesh_all_reset_alpha(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_reset_alpha(mesh, i);
    }
}

function mesh_reset_alpha(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        buffer_poke(buffer, position + 35, buffer_u8, 255);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
}

function mesh_all_reset_color(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_reset_color(mesh, i);
    }
}

function mesh_reset_color(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        buffer_poke(buffer, position + 32, buffer_u8, 255);
        buffer_poke(buffer, position + 33, buffer_u8, 255);
        buffer_poke(buffer, position + 34, buffer_u8, 255);
        buffer_seek(buffer, buffer_seek_relative, VERTEX_SIZE);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
}

function mesh_set_all_flip_tex_h(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_set_flip_tex_h(mesh, i);
    }
}

function mesh_set_all_flip_tex_v(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_set_flip_tex_v(mesh, i);
    }
}

function mesh_set_all_scale(mesh, scale) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_set_scale(mesh, i, scale);
    }
}

function mesh_set_flip_tex_h(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
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
}

function mesh_set_flip_tex_v(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
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
}

function mesh_set_scale(mesh, index, scale) {
    if (mesh.type == MeshTypes.SMF) return;
    
    var submesh = mesh.submeshes[index];
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
}