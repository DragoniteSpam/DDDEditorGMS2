function ui_render_surface_render_mesh_ed(mx, my) {
    draw_clear(c_black);
    
    var indices = self.root.GetSibling("MESH LIST").GetAllSelectedIndices();
    
    Stuff.mesh_ed.camera.SetProjection();
    
    gpu_set_ztestenable(true);
    gpu_set_zwriteenable(true);
    
    matrix_set(matrix_world, matrix_build_identity());
    shader_set(shd_wireframe);
    if (Settings.mesh.draw_grid) vertex_submit(Stuff.graphics.grid_centered, pr_linelist, -1);
    shader_set(shd_basic_colors);
    if (Settings.mesh.draw_axes) vertex_submit(Stuff.graphics.axes_center, pr_trianglelist, -1);
    
    shader_set(shd_ddd);
    
    #region light stuff
    var light_data = array_create(MAX_LIGHTS * 12);
    array_clear(light_data, 0);
    var ambient = Settings.mesh.draw_lighting ? c_gray : c_white;
    
    light_data[0] = dcos(Settings.mesh.draw_light_direction);
    light_data[1] = -dsin(Settings.mesh.draw_light_direction);
    light_data[2] = -1;  // this feels upside-down
    light_data[3] = LightTypes.DIRECTIONAL;
    light_data[8] = 1;
    light_data[9] = 1;
    light_data[10] = 1;
    
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
    
    wireframe_enable(Settings.mesh.wireframe_alpha);
    
    #endregion
    
    // so that gmedit stops yelling at me
    var tex_none = -1;
    
    gpu_set_cullmode(Settings.mesh.draw_back_faces ? cull_noculling : cull_counterclockwise);
    var mat_translate = matrix_build(Settings.mesh.draw_position.x, Settings.mesh.draw_position.y, Settings.mesh.draw_position.z, 0, 0, 0, 1, 1, 1);
    var mat_rotate = matrix_build(0, 0, 0, Settings.mesh.draw_rotation.x, Settings.mesh.draw_rotation.y, Settings.mesh.draw_rotation.z, 1, 1, 1);
    var mat_scale = matrix_build(0, 0, 0, 0, 0, 0, Settings.mesh.draw_scale.x, Settings.mesh.draw_scale.y, Settings.mesh.draw_scale.z,);
    matrix_set(matrix_world, matrix_multiply(matrix_multiply(mat_scale, mat_rotate), mat_translate));
    
    var rendered_count = 0;
    var limit = 10;
    var def_tex = sprite_get_texture(ACTIVE_TILESET().picture, 0);
    for (var index = 0, visible_mesh_count = array_length(indices); index < visible_mesh_count; index++) {
        var mesh_data = Game.meshes[real(indices[index])];
        switch (mesh_data.type) {
            case MeshTypes.RAW:
                var this_tex = -1;
                if (mesh_data.tex_base != NULL && Settings.mesh.draw_textures) {
                    this_tex = guid_get(mesh_data.tex_base) ? sprite_get_texture(guid_get(mesh_data.tex_base).picture, 0) : def_tex;
                }
                for (var sm_index = 0; sm_index < array_length(mesh_data.submeshes); sm_index++) {
                    var vbuffer = mesh_data.submeshes[sm_index].vbuffer;
                    var reflect_vbuffer = mesh_data.submeshes[sm_index].reflect_vbuffer;
                    if (Settings.mesh.draw_meshes && vbuffer) vertex_submit(vbuffer, pr_trianglelist, this_tex);
                    if (Settings.mesh.draw_reflections && Settings.mesh.draw_meshes && reflect_vbuffer) vertex_submit(reflect_vbuffer, pr_trianglelist, this_tex);
                    
                    if (Settings.mesh.draw_collision) {
                        for (var i = 0, len = array_length(mesh_data.collision_shapes); i < len; i++) {
                            shader_set(shd_wireframe);
                            var shape = mesh_data.collision_shapes[i];
                            switch (shape.type) {
                                
                                case MeshCollisionShapes.BOX:
                                    matrix_set(matrix_world, matrix_build(shape.position.x, shape.position.y, shape.position.z, shape.rotation.x, shape.rotation.y, shape.rotation.z, shape.scale.x, shape.scale.y, shape.scale.z));
                                    vertex_submit(Stuff.graphics.wire_box, pr_linelist, tex_none);
                                    break;
                                case MeshCollisionShapes.CAPSULE:
                                    // the capsule transformation isn't perfect but honestly i dont know if i can be bothered to do it right
                                    matrix_set(matrix_world, matrix_build(shape.position.x, shape.position.y, shape.position.z, shape.rotation.x, shape.rotation.y, shape.rotation.z, shape.radius, shape.radius, shape.length));
                                    vertex_submit(Stuff.graphics.wire_capsule, pr_linelist, tex_none);
                                    break;
                                case MeshCollisionShapes.SPHERE:
                                    matrix_set(matrix_world, matrix_build(shape.position.x, shape.position.y, shape.position.z, 0, 0, 0, shape.radius, shape.radius, shape.radius));
                                    vertex_submit(Stuff.graphics.wire_sphere, pr_linelist, tex_none);
                                    break;
                            }
                        
                            matrix_set(matrix_world, matrix_build_identity());
                            shader_set(shd_ddd);
                        }
                    }
                }
                break;
        }
        if (++rendered_count > limit) break;
    }
    
    matrix_set(matrix_world, matrix_build_identity());
    shader_reset();
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    gpu_set_cullmode(cull_noculling);
    return;
    #region draw the overlay
    var cwidth = camera_get_view_width(cam);
    var cheight = camera_get_view_height(cam);
    camera_set_view_mat(cam, matrix_build_lookat(cwidth / 2, cheight / 2, 16000,  cwidth / 2, cheight / 2, -16000, 0, 1, 0));
    camera_set_proj_mat(cam, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(cam);
    
    scribble("[c_white]Use WASD to fly around, and hold the middle mouse button to aim the camera")
        .align(fa_left, fa_top)
        .wrap(-1, -1)
        .draw(20, 20);
    
    scribble("[c_white]Use Q and E to rotate the light source")
        .align(fa_left, fa_top)
        .wrap(-1, -1)
        .draw(20, 40);
    
    // this is like draw_camera_controls_overlay but different enough that i
    // don't want to generic-ize it
    var iconx = 32;
    var icony = sh - 32;
    var iconlength = 16;
    
    var inbounds = mouse_within_rectangle(iconx - iconlength + x1, icony - iconlength + y1, iconx + iconlength + x1, icony + iconlength + y1);
    var c = inbounds ? c_ui_select : c_white;
    draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c, c, false);
    draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c_black, c_black, true);
    draw_sprite(spr_camera_icons, 2, iconx - sprite_get_width(spr_camera_icons) / 2, icony - sprite_get_height(spr_camera_icons) / 2);
    
    if ((inbounds && Controller.release_left) || keyboard_check(vk_f1)) {
        mode.ResetCamera();
    }
    #endregion
}