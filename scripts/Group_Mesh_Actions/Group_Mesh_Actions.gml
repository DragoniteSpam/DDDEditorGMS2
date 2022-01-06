function mesh_mirror_all_x(mesh) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_mirror_axis_x(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer));
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_mirror_axis_x(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer));
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_mirror_all_y(mesh) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_mirror_axis_y(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer));
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_mirror_axis_y(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer));
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_mirror_all_z(mesh) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_mirror_axis_y(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer));
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_mirror_axis_y(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer));
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_rotate_all_up_axis(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        mesh_rotate_up_axis(mesh, i);
    }
}

function mesh_rotate_up_axis(mesh, index) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_rotate_up(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer));
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_rotate_up(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer));
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_all_invert_alpha(mesh) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_invert_alpha(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer));
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_invert_alpha(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer));
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_all_reset_alpha(mesh) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_set_alpha(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer), 1);
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_set_alpha(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer), 1);
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_all_reset_color(mesh) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_set_color(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer), c_white);
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_set_color(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer), c_white);
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_set_all_flip_tex_h(mesh) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_flip_tex_u(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer));
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_flip_tex_u(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer));
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_set_all_flip_tex_v(mesh) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_flip_tex_v(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer));
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_flip_tex_v(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer));
            submesh.internalSetReflectVertexBuffer();
        }
    }
}

function mesh_set_all_scale(mesh, scale) {
    if (mesh.type == MeshTypes.SMF) return;
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        meshops_transform_scale(buffer_get_address(submesh.buffer), buffer_get_size(submesh.buffer), scale);
        submesh.internalSetVertexBuffer();
        if (submesh.reflect_buffer) {
            meshops_transform_scale(buffer_get_address(submesh.reflect_buffer), buffer_get_size(submesh.reflect_buffer), scale);
            submesh.internalSetReflectVertexBuffer();
        }
    }
}