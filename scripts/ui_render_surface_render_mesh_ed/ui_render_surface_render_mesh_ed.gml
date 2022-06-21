function ui_render_surface_render_mesh_ed(mx, my) {
    draw_clear(c_black);
    
    var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
    
    Stuff.mesh.camera.SetProjection();
    
    gpu_set_ztestenable(true);
    gpu_set_zwriteenable(true);
    
    if (Settings.mesh.draw_grid) Stuff.graphics.DrawGridCentered();
    if (Settings.mesh.draw_axes) Stuff.graphics.DrawAxes();
    
    shader_set(shd_ddd);
    
    #region light stuff
    var light_data = array_create(MAX_LIGHTS * 12, 0);
    var ambient = Settings.mesh.draw_lighting ? c_dkgray : c_white;
    
    light_data[0] = dcos(Settings.mesh.draw_light_direction);
    light_data[1] = -dsin(Settings.mesh.draw_light_direction);
    light_data[2] = -1;  // this feels upside-down
    light_data[3] = LightTypes.DIRECTIONAL;
    light_data[8] = 0.75;
    light_data[9] = 0.75;
    light_data[10] = 0.75;
    
    var time_color = c_white;
    var weather_color = c_white;
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "lightBuckets"), 255);
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "lightAmbientColor"), (ambient & 0x0000ff) / 0xff, ((ambient & 0x00ff00) >> 8) / 0xff, ((ambient & 0xff0000) >> 16) / 0xff);
        shader_set_uniform_f(shader_get_uniform(shd_ddd, "lightDayTimeColor"), (time_color & 0x0000ff) / 0xff, ((time_color & 0x00ff00) >> 8) / 0xff, (time_color >> 16) / 0xff);
        shader_set_uniform_f(shader_get_uniform(shd_ddd, "lightWeatherColor"), (weather_color & 0x0000ff) / 0xff, ((weather_color & 0x00ff00) >> 8) / 0xff, (weather_color >> 16) / 0xff);
    shader_set_uniform_f_array(shader_get_uniform(shd_ddd, "lightData"), light_data);
    
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "fogStrength"), 0);
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "fogStart"), CAMERA_ZFAR * 2);
    shader_set_uniform_f(shader_get_uniform(shd_ddd, "fogEnd"), CAMERA_ZFAR * 3);
    #endregion
    
    wireframe_enable(Settings.mesh.wireframe_alpha);
    
    gpu_set_cullmode(Settings.mesh.draw_back_faces ? cull_noculling : cull_counterclockwise);
    var mat_translate = matrix_build(Settings.mesh.draw_position.x, Settings.mesh.draw_position.y, Settings.mesh.draw_position.z, 0, 0, 0, 1, 1, 1);
    var mat_rotate = matrix_build(0, 0, 0, Settings.mesh.draw_rotation.x, Settings.mesh.draw_rotation.y, Settings.mesh.draw_rotation.z, 1, 1, 1);
    var mat_scale = matrix_build(0, 0, 0, 0, 0, 0, Settings.mesh.draw_scale.x, Settings.mesh.draw_scale.y, Settings.mesh.draw_scale.z,);
    matrix_set(matrix_world, matrix_multiply(matrix_multiply(mat_scale, mat_rotate), mat_translate));
    
    var rendered_count = 0;
    var limit = 24;
    if (Settings.mesh.draw_meshes) {
        for (var index = 0, visible_mesh_count = array_length(indices); index < visible_mesh_count; index++) {
            var mesh_data = self.root.GetSibling("MESH LIST").At(real(indices[index]));
            switch (mesh_data.type) {
                case MeshTypes.RAW:
                    for (var sm_index = 0; sm_index < array_length(mesh_data.submeshes); sm_index++) {
                        var submesh = mesh_data.submeshes[sm_index];
                        if (!submesh.editor_visible) continue;
                        var vbuffer = submesh.vbuffer;
                        var reflect_vbuffer = submesh.reflect_vbuffer;
                        var submesh_tex = -1;
                        if (Settings.mesh.draw_textures && guid_get(submesh.tex_base)) {
                             submesh_tex = sprite_get_texture(guid_get(submesh.tex_base).picture, 0);
                        }
                        if (vbuffer) vertex_submit(vbuffer, pr_trianglelist, submesh_tex);
                        if (Settings.mesh.draw_reflections && reflect_vbuffer) vertex_submit(reflect_vbuffer, pr_trianglelist, submesh_tex);
                    }
                    break;
            }
        
            if (++rendered_count > limit) break;
        }
    }
    
    if (Settings.mesh.draw_collision) {
        var rendered_count = 0;
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
                        Stuff.graphics.DrawWireSphere(shape.position.x, shape.position.y, shape.position.z, 0, 0, 0, shape.radius, shape.radius, shape.radius);
                        break;
                }
            }
            
            if (++rendered_count > limit) break;
        }
    }
    
    shader_reset();
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    
    #region draw the overlay
    Stuff.mesh.camera.SetProjectionGUI();
    
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
    
    // i legitimately dont know why the vertical offset here needs to be 32 and not self.y
    editor_gui_button(spr_camera_icons, 2, 16, self.height - 48, self.x, 32, null, function() {
        Stuff.mesh.camera.Reset();
    });
    #endregion
}