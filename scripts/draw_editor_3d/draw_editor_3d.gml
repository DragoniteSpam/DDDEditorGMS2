function draw_editor_3d() {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    draw_set_color(c_white);
    gpu_set_cullmode(Settings.view.backface ? cull_noculling : cull_counterclockwise);
    
    var camera = view_get_camera(view_current);
    var z2d = 1600;
    
    if (Settings.view.threed) {
        var vw = view_get_wport(view_current);
        var vh = view_get_hport(view_current);
        camera_set_view_mat(camera, matrix_build_lookat(x, y, z, xto, yto, zto, xup, yup, zup));
        camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
        camera_apply(camera);
    } else {
        var cwidth = camera_get_view_width(camera);
        var cheight = camera_get_view_height(camera);
        camera_set_view_mat(camera, matrix_build_lookat(x, y, z2d,  x, y, -16000, 0, 1, 0));
        camera_set_proj_mat(camera, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
        camera_apply(camera);
    }
    
    // skyboxes go first
    var skybox = guid_get(map.skybox);
    if (skybox && !map.indoors) {
        gpu_set_zwriteenable(false);
        gpu_set_ztestenable(false);
        transform_set(x, y, Settings.view.threed ? z : z2d, 0, 0, 0, 1, 1, 1);
        vertex_submit(Stuff.graphics.skybox_base, pr_trianglelist, sprite_get_texture(skybox.picture, 0));
        matrix_set(matrix_world, matrix_build_identity());
    }
    
    gpu_set_zwriteenable(true);
    gpu_set_ztestenable(true);
    
    // axes
    shader_set(shd_basic_colors);
    vertex_submit(Stuff.graphics.axes, pr_trianglelist, -1);
    
    graphics_set_lighting(shd_ddd);
    
    // this will need to be dynamic at some point
    var tex = Settings.view.texture ? sprite_get_texture(get_active_tileset().picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
    
    #region entities
    if (Settings.view.entities) {
        if (map_contents.frozen) {
            vertex_submit(map_contents.frozen, pr_trianglelist, tex);
        }
        if (map.reflections_enabled && map_contents.reflect_frozen) {
            vertex_submit(map_contents.reflect_frozen, pr_trianglelist, tex);
        }
        
        if (map_contents.frozen) {
            wireframe_enable();
            vertex_submit(map_contents.frozen, pr_trianglelist, tex);
            if (map.reflections_enabled && map_contents.reflect_frozen) {
                vertex_submit(map_contents.reflect_frozen, pr_trianglelist, tex);
            }
            wireframe_disable();
        }
        
        for (var i = 0, n = array_length(map_contents.batches); i < n; i++) {
            var data = map_contents.batches[i];
            vertex_submit(data.vertex, pr_trianglelist, tex);
            if (map.reflections_enabled) {
                vertex_submit(data.reflect_vertex, pr_trianglelist, tex);
            }
        }
        
        if (Settings.view.wireframe) {
            wireframe_enable();
            for (var i = 0, n = array_length(map_contents.batches); i < n; i++) {
                var data = map_contents.batches[i];
                vertex_submit(data.vertex, pr_trianglelist, tex);
                if (map.reflections_enabled) {
                    vertex_submit(data.reflect_vertex, pr_trianglelist, tex);
                }
            }
            wireframe_disable();
        }
    }
    
    for (var i = 0; i < ds_list_size(map_contents.batch_in_the_future); i++) {
        map_contents.batch_in_the_future[| i].render(map_contents.batch_in_the_future[| i]);
        // batchable entities don't make use of move routes, so don't bother
    }
    
    // the water effect uses a different shader
    graphics_draw_water();
    
    // reset the lighting shader after the water has been drawn
    graphics_set_lighting(shd_ddd);
    for (var i = 0; i < ds_list_size(map_contents.dynamic); i++) {
        map_contents.dynamic[| i].render(map_contents.dynamic[| i]);
    }
    #endregion
    
    shader_reset();
    gpu_set_cullmode(cull_noculling);
    
    #region grids, selection boxes, zones
    if (Settings.view.grid) {
        shader_set(shd_wireframe);
        transform_set(0, 0, Stuff.map.edit_z * TILE_DEPTH + 0.5, 0, 0, 0, 1, 1, 1);
        vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
        shader_set(shd_ddd);
    }
    
    // tried using ztestenable for this - didn't look good. at all.
    for (var i = 0, n = array_length(Stuff.map.selection); i < n; i++) {
        Stuff.map.selection[i].render();
    }
    
    if (Settings.view.zones) {
        for (var i = 0, n = array_length(map_contents.all_zones); i < n; i++) {
            map_contents.all_zones[i].Render();
        }
    }
    #endregion
    
    #region unlit meshes - UI stuff like axes and gizmos
    if (Game.meta.start.map == Stuff.map.active_map.GUID) {
        transform_set(0, 0, 0, 0, 0, Stuff.direction_lookup[Game.meta.start.direction], 1, 1, 1);
        transform_add((Game.meta.start.x + 0.5) * TILE_WIDTH, (Game.meta.start.y + 0.5) * TILE_HEIGHT, Game.meta.start.z * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
        vertex_submit(Stuff.graphics.basic_cage, pr_trianglelist, -1);
    }
    
    // check for the gizmo setting in the actual events where this list is contributed
    // to - there may be some you want to draw regardless, like component axes
    while (!ds_queue_empty(Stuff.unlit_meshes)) {
        var data = ds_queue_dequeue(Stuff.unlit_meshes);
        var vbuffer = data[0];
        var transform = data[1];
        matrix_set(matrix_world, transform);
        vertex_submit(vbuffer, pr_trianglelist, -1);
    }
    #endregion
    
    matrix_set(matrix_world, matrix_build_identity());
    shader_reset();
    
    #region overlay stuff - draw_camera_controls_overlay exists, but i'd actually rather not use it for this
    gpu_set_ztestenable(false);
    var cwidth = camera_get_view_width(camera);
    var cheight = camera_get_view_height(camera);
    camera_set_view_mat(camera, matrix_build_lookat(cwidth / 2, cheight / 2, 16000,  cwidth / 2, cheight / 2, -16000, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
    
    #region height controls
    // base bar
    var height = clamp(24 * Stuff.map.active_map.zz, 64, 640);
    var sw = sprite_get_width(spr_vertical_bar);
    var sh = sprite_get_height(spr_vertical_bar);
    var bw = sprite_get_width(spr_plus_minus_button);
    var bh = sprite_get_height(spr_plus_minus_button);
    var yy_start = 64 + bh;
    var yy_end = 64 + height - bh;
    draw_sprite_stretched(spr_vertical_bar, 0, 32 - sw / 2, 64, sw, height);
    
    // bar notches
    var notch_count = min(power(2, floor(log2(max(Stuff.map.active_map.zz, 2)))), 16);
    for (var i = 0; i < notch_count; i++) {
        var yy_notch = yy_start + i * (yy_end - yy_start) / (notch_count - 1);
        draw_line_width_colour(32 - bw / 4, yy_notch, 32 + bw / 4, yy_notch, 2, c_ui_select, c_ui_select);
    }
    
    // buttons
    var overlap_plus = mouse_within_rectangle_view(32 - bw / 2, 64 - bh / 2, 32 + bw / 2, 64 + bh / 2);
    var overlap_minus = mouse_within_rectangle_view(32 - bw / 2, 64 + height - bh / 2, 32 + bw / 2, 64 + height + bh / 2);
    draw_sprite_ext(spr_plus_minus_button, 0, 32, 64, 1, 1, 0, overlap_plus ? c_ui_select : c_white, 1);
    draw_sprite_ext(spr_plus_minus_button, 1, 32, height + 64, 1, 1, 0, overlap_minus ? c_ui_select : c_white, 1);
    
    // slider
    var slider_length = height - bh * 2;
    var interval = slider_length / (Stuff.map.active_map.zz - 1);
    var slider_y = 64 + height - bh - Stuff.map.edit_z * interval;
    var slw = sprite_get_width(spr_drag_handle_vertical);
    var slh = sprite_get_height(spr_drag_handle_vertical);
    var overlap_slider = mouse_within_rectangle_view(32 - slw / 2, slider_y - slh / 2, 32 + slw / 2, slider_y + slh / 2);
    draw_sprite_ext(spr_drag_handle_vertical, 0, 32, slider_y, 1, 1, 0, overlap_slider ? c_ui_select : c_white, 1);
    
    // interactions
    if (ds_list_empty(Stuff.dialogs)) {
        var overlap_interval = mouse_within_rectangle_view(32 - slw / 2, 64, 32 + slw / 2, 64 + height);
        
        if (overlap_plus) {
            if (mouse_check_button_pressed(mb_left)) {
                Stuff.map.edit_z = min(++Stuff.map.edit_z, Stuff.map.active_map.zz - 1);
            }
            mouse_over_ui = true;
        } else if (overlap_minus) {
            if (mouse_check_button_pressed(mb_left)) {
                Stuff.map.edit_z = max(--Stuff.map.edit_z, 0);
            }
            mouse_over_ui = true;
        } else if (overlap_interval) {
            if (mouse_check_button(mb_left)) {
                var f = clamp((yy_end - mouse_y_view) / (yy_end - yy_start), 0, 1);
                Stuff.map.edit_z = round(f * (Stuff.map.active_map.zz - 1));
            }
            mouse_over_ui = true;
        }
    }
    #endregion
    
    #region icons
    while (!ds_queue_empty(Stuff.screen_icons)) {
        var data = ds_queue_dequeue(Stuff.screen_icons);
        var sprite = data[0];
        var position = data[1];
        draw_sprite(sprite, 0, position[vec3.xx], position[vec3.yy]);
    }
    #endregion
    #endregion
}