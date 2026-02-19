function ui_render_surface_render_mesh_ed(mx, my) {
    draw_clear(c_black);
    
    var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
    
    Stuff.mesh.camera.SetProjection();
    
    gpu_set_ztestenable(true);
    gpu_set_zwriteenable(true);
    gpu_set_texrepeat(true);
    
    if (Settings.mesh.draw_grid) Stuff.graphics.DrawGridCentered();
    if (Settings.mesh.draw_axes) Stuff.graphics.DrawAxes();
    
    shader_set(shd_ddd);
    
    #region light stuff
    var light_data = array_create(MAX_LIGHTS * 12, 0);
    var ambient = Settings.mesh.draw_lighting ? Stuff.mesh.light_color : c_white;
    
    var light_actual = Stuff.mesh.light.Normalize();
    
    light_data[0] = -light_actual.x;
    light_data[1] = -light_actual.y;
    light_data[2] = -light_actual.z;
    light_data[3] = LightTypes.DIRECTIONAL;
    light_data[8] = 0.9;
    light_data[9] = 0.9;
    light_data[10] = 0.9;
    
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "lightBuckets"), 255);
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "lightAmbientColor"), (ambient & 0x0000ff) / 0xff, ((ambient & 0x00ff00) >> 8) / 0xff, ((ambient & 0xff0000) >> 16) / 0xff);
    shader_set_uniform_f_array(shader_get_uniform(shd_ddd, "lightData"), light_data);
    
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "fogStrength"), 0);
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "fogStart"), CAMERA_ZFAR * 2);
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "fogEnd"), CAMERA_ZFAR * 3);
    
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "u_DrawVertexColors"), Settings.mesh.draw_vertex_colors);
    #endregion
    
    wireframe_enable(Settings.mesh.wireframe_alpha);
    
    gpu_set_cullmode(Settings.mesh.draw_back_faces ? cull_noculling : cull_counterclockwise);
    var mat_translate = matrix_build(Settings.mesh.draw_position.x, Settings.mesh.draw_position.y, Settings.mesh.draw_position.z, 0, 0, 0, 1, 1, 1);
    var mat_rotate = matrix_build(0, 0, 0, Settings.mesh.draw_rotation.x, Settings.mesh.draw_rotation.y, Settings.mesh.draw_rotation.z, 1, 1, 1);
    var mat_scale = matrix_build(0, 0, 0, 0, 0, 0, Settings.mesh.draw_scale.x, Settings.mesh.draw_scale.y, Settings.mesh.draw_scale.z);
    var mat_transform = matrix_multiply(matrix_multiply(mat_scale, mat_rotate), mat_translate);
    matrix_set(matrix_world, mat_transform);
    
    var rendered_count = 0;
    var limit = 24;
    for (var index = 0, visible_mesh_count = array_length(indices); index < visible_mesh_count; index++) {
        var mesh_data = self.root.GetSibling("MESH LIST").At(real(indices[index]));
        switch (mesh_data.type) {
            case MeshTypes.RAW:
                for (var sm_index = 0; sm_index < array_length(mesh_data.submeshes); sm_index++) {
                    var submesh = mesh_data.submeshes[sm_index];
                    if (!submesh.editor_visible) continue;
                    
                    if (Stuff.mesh.GetHighlightedSubmesh(submesh)) {
                        wireframe_enable(1, 512, c_aqua, 0.5);
                    }
                    
                    graphics_set_material(submesh);
                    
                    var submesh_tex = -1;
                    if (Settings.mesh.draw_textures) {
                        if (guid_get(submesh.tex_base)) {
                            submesh_tex = sprite_get_texture(guid_get(submesh.tex_base).picture, 0);
                        } else if (submesh.tex_base != NULL) {
                            submesh_tex = TEX_MISSING;
                        }
                    }
                    if (submesh.vbuffer) vertex_submit(submesh.vbuffer, pr_trianglelist, submesh_tex);
                    if (Settings.mesh.draw_reflections && submesh.reflect_vbuffer) vertex_submit(submesh.reflect_vbuffer, pr_trianglelist, submesh_tex);
                    
                    wireframe_enable(Settings.mesh.wireframe_alpha);
                }
                break;
        }
        
        if (++rendered_count > limit) break;
    }
    
    if (Settings.mesh.draw_collision) {
        rendered_count = 0;
        for (var index = 0, visible_mesh_count = array_length(indices); index < visible_mesh_count; index++) {
            var mesh_data = self.root.GetSibling("MESH LIST").At(real(indices[index]));
            for (var i = 0, len = array_length(mesh_data.collision_shapes); i < len; i++) {
                var shape = mesh_data.collision_shapes[i];
                switch (shape.type) {
                    case MeshCollisionShapes.BOX:
                        Stuff.graphics.DrawWireBox(shape.position.x, shape.position.y, shape.position.z, shape.rotation.x, shape.rotation.y, shape.rotation.z, shape.scale.x, shape.scale.y, shape.scale.z);
                        break;
                    case MeshCollisionShapes.CAPSULE:
                        // the capsule transformation isn't perfect but honestly i dont know if i can be bothered to do it right
                        Stuff.graphics.DrawWireCapsule(shape.position.x, shape.position.y, shape.position.z, shape.rotation.x, shape.rotation.y, shape.rotation.z, shape.radius, shape.radius, shape.length);
                        break;
                    case MeshCollisionShapes.SPHERE:
                        Stuff.graphics.DrawWireSphere(shape.position.x, shape.position.y, shape.position.z, 0, 0, 0, shape.diameter, shape.diameter, shape.diameter);
                        break;
                }
            }
            
            if (++rendered_count > limit) break;
        }
    }
    
    if (Settings.mesh.draw_physical_bounds) {
        rendered_count = 0;
        for (var index = 0, visible_mesh_count = array_length(indices); index < visible_mesh_count; index++) {
            var mesh = self.root.GetSibling("MESH LIST").At(real(indices[index]));
            var bounds = mesh.physical_bounds;
            var point_000 = matrix_transform_vertex(mat_transform, bounds.x1, bounds.y1, bounds.z1);
            var point_001 = matrix_transform_vertex(mat_transform, bounds.x1, bounds.y1, bounds.z2);
            var point_010 = matrix_transform_vertex(mat_transform, bounds.x1, bounds.y2, bounds.z1);
            var point_011 = matrix_transform_vertex(mat_transform, bounds.x1, bounds.y2, bounds.z2);
            var point_100 = matrix_transform_vertex(mat_transform, bounds.x2, bounds.y1, bounds.z1);
            var point_101 = matrix_transform_vertex(mat_transform, bounds.x2, bounds.y1, bounds.z2);
            var point_110 = matrix_transform_vertex(mat_transform, bounds.x2, bounds.y2, bounds.z1);
            var point_111 = matrix_transform_vertex(mat_transform, bounds.x2, bounds.y2, bounds.z2);
            var bounds_x1 = min(point_000[0], point_001[0], point_010[0], point_011[0], point_100[0], point_101[0], point_110[0], point_111[0]);
            var bounds_y1 = min(point_000[1], point_001[1], point_010[1], point_011[1], point_100[1], point_101[1], point_110[1], point_111[1]);
            var bounds_z1 = min(point_000[2], point_001[2], point_010[2], point_011[2], point_100[2], point_101[2], point_110[2], point_111[2]);
            var bounds_x2 = max(point_000[0], point_001[0], point_010[0], point_011[0], point_100[0], point_101[0], point_110[0], point_111[0]);
            var bounds_y2 = max(point_000[1], point_001[1], point_010[1], point_011[1], point_100[1], point_101[1], point_110[1], point_111[1]);
            var bounds_z2 = max(point_000[2], point_001[2], point_010[2], point_011[2], point_100[2], point_101[2], point_110[2], point_111[2]);
            Stuff.graphics.DrawWireBox(
                mean(bounds_x1, bounds_x2), mean(bounds_y1, bounds_y2), mean(bounds_z1, bounds_z2),
                0, 0, 0,
                abs(bounds_x2 - bounds_x1), abs(bounds_y2 - bounds_y1), abs(bounds_z2 - bounds_z1),
                c_red
            );
        }
    }
    
    shader_reset();
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    
    #region draw the overlay
    Stuff.mesh.camera.SetProjectionGUI();
    
    if (Settings.mesh.draw_3d_view_overlay_text) {
        scribble("[FDefaultOutline][c_white]Use WASD to fly around, Shift to move faster, and the")
            .align(fa_left, fa_top)
            .wrap(-1, -1)
            .draw(20, 20);
        scribble("[FDefaultOutline][c_white]middle mouse button to aim the camera")
            .align(fa_left, fa_top)
            .wrap(-1, -1)
            .draw(20, 40);
        scribble("[FDefaultOutline][c_white]Use Q and E to rotate the light source")
            .align(fa_left, fa_top)
            .wrap(-1, -1)
            .draw(20, 60);
    }
    
    // i legitimately dont know why the vertical offset here needs to be 32 and not self.y
    editor_gui_button(spr_camera_icons, 2, 16, self.height - 48, self.x, 32, null, function() {
        Stuff.mesh.camera.Reset();
    });
    #endregion
}