function draw_editor_particle(mode) {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    var camera = camera_get_active();
    var ww = camera_get_view_width(camera);
    var hh = camera_get_view_height(camera);
    
    gpu_set_zwriteenable(false);
    gpu_set_ztestenable(false);
    gpu_set_cullmode(cull_counterclockwise);
    transform_set(0, 0, 0, 0, 0, 0, 1, 1, 1);
    
    draw_clear(mode.back_color);
    vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
    draw_set_alpha(0.75);
    draw_set_color(mode.back_color);
    draw_rectangle(0, 0, ww, hh, false);
    draw_set_color(c_white);
    draw_set_alpha(1);
    
    if (Controller.mouse_right || Controller.press_left) {
        if (mouse_within_view(view_current) && ds_list_empty(Stuff.dialogs) && !mode.emitter_setting) {
            var emitter = mode.emitters[ui_list_selection(mode.ui.t_emitter.list)];
            if (emitter && emitter.type) {
                part_particles_create(mode.system, mouse_x_view, mouse_y_view, emitter.type.type, emitter.rate * Stuff.dt)
            }
        }
    }
    
    var tex_checker = sprite_get_texture(b_tileset_checkers, 0);
    var base_ref = gpu_get_alphatestref();
    gpu_set_alphatestref(0.05);
    
    for (var i = 0; i < array_length(mode.emitters); i++) {
        if (mode.emitters[i].draw_region) vertex_submit(mode.emitters[i].region, pr_trianglelist, tex_checker);
    }
    
    part_system_drawit(mode.system);
    
    for (var i = 0; i < array_length(mode.emitters); i++) {
        if (mode.emitters[i].draw_region) vertex_submit(mode.emitters[i].region, pr_trianglelist, tex_checker);
    }
    
    gpu_set_alphatestref(base_ref);
    
    if (mode.emitter_setting) {
        var emitter = mode.emitter_setting;
        draw_set_alpha(0.75);
        draw_set_colour(c_black);
        var kill = false;
        var mx = mode.emitter_set_snap ? round_ext(mouse_x_view, mode.emitter_set_snap_size) : mouse_x_view;
        var my = mode.emitter_set_snap ? round_ext(mouse_y_view, mode.emitter_set_snap_size) : mouse_y_view;
        
        if (mode.emitter_first_corner) {
            if (Controller.mouse_left) {
                if (mouse_x_view < view_get_wport(view_current)) {
                    mode.emitter_first_corner = false;
                    emitter.region_x1 = mx;
                    emitter.region_y1 = my;
                } else {
                    kill = true;
                }
            }
            
            if (Controller.release_right) {
                kill = true;
            }
            
            draw_rectangle(0, 0, ww, hh, false);
        } else {
            if (Controller.mouse_left) {
                mode.emitter_first_corner = false;
                emitter.region_x2 = mx;
                emitter.region_y2 = my;
            }
            
            var xmn = min(emitter.region_x1, emitter.region_x2);
            var ymn = min(emitter.region_y1, emitter.region_y2);
            var xmx = max(emitter.region_x1, emitter.region_x2);
            var ymx = max(emitter.region_y1, emitter.region_y2);
            
            draw_rectangle(0, 0, xmn, hh, false);
            draw_rectangle(xmx + 1, 0, ww, hh, false);
            // things don't look super good if you try to draw zero-width rectangles
            if (xmn != xmx) {
                draw_rectangle(xmn + 1, 0, xmx, ymn, false);
                draw_rectangle(xmn + 1, ymx, xmx, hh, false);
            }
            
            if (Controller.release_left) {
                part_system_automatic_update(mode.system, mode.system_auto_update);
                editor_particle_emitter_set_region(emitter);
                editor_particle_emitter_create_region(emitter);
                ui_particle_emitter_select(mode.ui.t_emitter.list);
                kill = true;
            }
        }
        
        draw_set_alpha(1);
        draw_set_colour(c_white);
        
        if (kill) {
            mode.ui.el_set_region.click_time = current_time;
            mode.emitter_setting = noone;
            dialog_destroy();
        }
    }
}