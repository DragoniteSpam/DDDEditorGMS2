function ui_render_surface_render_mesh_ed(surface, x1, y1, x2, y2) {
    var mode = Stuff.mesh_ed;
    var mesh_list = surface.root.mesh_list;
    var sw = surface_get_width(surface.surface);
    var sh = surface_get_height(surface.surface);
    draw_clear(c_black);
    
    var cam = camera_get_active();
    camera_set_view_mat(cam, matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup));
    camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-mode.fov, -sw / sh, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(cam);
    
    gpu_set_ztestenable(true);
    gpu_set_zwriteenable(true);
    
    matrix_set(matrix_world, matrix_build_identity());
    if (mode.draw_grid) vertex_submit(Stuff.graphics.mesh_preview_grid, pr_linelist, -1);
    if (mode.draw_axes) vertex_submit(Stuff.graphics.axes_width, pr_linelist, -1);
    
    shader_set(shd_ddd);
    
    #region light stuff
    var light_data = array_create(MAX_LIGHTS * 12);
    array_clear(light_data, 0);
    var ambient = mode.draw_lighting ? c_gray : c_white;
    
    light_data[0] = dcos(mode.draw_light_direction);
    light_data[1] = -dsin(mode.draw_light_direction);
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
    #endregion
    
    gpu_set_cullmode(Stuff.mesh_ed.draw_back_faces ? cull_noculling : cull_counterclockwise);
    transform_set(0, 0, 0, mode.draw_rot_x, mode.draw_rot_y, mode.draw_rot_z, mode.draw_scale, mode.draw_scale, mode.draw_scale);
    var n = 0;
    var limit = 10;
    var def_tex = sprite_get_texture(get_active_tileset().picture, 0);
    for (var index = ds_map_find_first(mesh_list.selected_entries); index != undefined; index = ds_map_find_next(mesh_list.selected_entries, index)) {
        var mesh_data = Game.meshes[index];
        switch (mesh_data.type) {
            case MeshTypes.RAW:
                var this_tex = -1;
                if (mesh_data.tex_base != NULL && mode.draw_textures) {
                    this_tex = guid_get(mesh_data.tex_base) ? sprite_get_texture(guid_get(mesh_data.tex_base).picture, 0) : def_tex;
                }
                for (var sm_index = 0; sm_index < array_length(mesh_data.submeshes); sm_index++) {
                    var vbuffer = mesh_data.submeshes[sm_index].vbuffer;
                    var wbuffer = mesh_data.submeshes[sm_index].wbuffer;
                    var reflect_vbuffer = mesh_data.submeshes[sm_index].reflect_vbuffer;
                    var reflect_wbuffer = mesh_data.submeshes[sm_index].reflect_wbuffer;
                    if (mode.draw_meshes && vbuffer) vertex_submit(vbuffer, pr_trianglelist, this_tex);
                    if (mode.draw_wireframes && wbuffer) vertex_submit(wbuffer, pr_linelist, -1);
                    if (mode.draw_reflections && mode.draw_meshes && reflect_vbuffer) vertex_submit(reflect_vbuffer, pr_trianglelist, this_tex);
                    if (mode.draw_reflections && mode.draw_wireframes && reflect_wbuffer) vertex_submit(reflect_wbuffer, pr_linelist, -1);
                }
                break;
        }
        if (++n > limit) break;
    }
    
    matrix_set(matrix_world, matrix_build_identity());
    shader_reset();
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    gpu_set_cullmode(cull_noculling);
    
    #region draw the overlay
    var cwidth = camera_get_view_width(cam);
    var cheight = camera_get_view_height(cam);
    camera_set_view_mat(cam, matrix_build_lookat(cwidth / 2, cheight / 2, 16000,  cwidth / 2, cheight / 2, -16000, 0, 1, 0));
    camera_set_proj_mat(cam, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(cam);
    
    scribble_set_wrap(-1, -1);
    scribble_set_box_align(fa_left, fa_top);
    scribble_draw(20, 20, "[c_white]Use WASD to fly around, and hold the middle mouse button to aim the camera");
    scribble_draw(20, 40, "[c_white]Use Q and E to rotate the light source");
    
    // this is like draw_camera_controls_overlay but different enough that i
    // don't want to generic-ize it
    var iconx = 32;
    var icony = sh - 32;
    var iconlength = 16;
    
    var inbounds = mouse_within_rectangle_view(iconx - iconlength + x1, icony - iconlength + y1, iconx + iconlength + x1, icony + iconlength + y1);
    var c = inbounds ? c_ui_select : c_white;
    draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c, c, false);
    draw_roundrect_colour(iconx - iconlength, icony - iconlength, iconx + iconlength, icony + iconlength, c_black, c_black, true);
    draw_sprite(spr_camera_icons, 2, iconx - sprite_get_width(spr_camera_icons) / 2, icony - sprite_get_height(spr_camera_icons) / 2);
    
    if ((inbounds && Controller.release_left) || keyboard_check(vk_f1)) {
        mode.x = mode.def_x;
        mode.y = mode.def_y;
        mode.z = mode.def_z;
        
        mode.xto = mode.def_xto;
        mode.yto = mode.def_yto;
        mode.zto = mode.def_zto;
        
        mode.xup = mode.def_xup;
        mode.yup = mode.def_yup;
        mode.zup = mode.def_zup;
        
        mode.fov = mode.def_fov;
        mode.pitch = darctan2(mode.z - mode.zto, point_distance(mode.x, mode.y, mode.xto, mode.yto));
        mode.direction = point_direction(mode.x, mode.y, mode.xto, mode.yto);
    }
    #endregion
}