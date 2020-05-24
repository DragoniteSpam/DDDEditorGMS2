/// @param EditorModeParticle

var mode = argument0;

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
        var emitter = mode.emitters[| ui_list_selection(mode.ui.t_emitter.list)];
        if (emitter && emitter.type) {
            part_particles_create(mode.system, mouse_x_view, mouse_y_view, emitter.type.type, emitter.rate * Stuff.dt)
        }
    }
}

part_system_drawit(mode.system);

if (mode.emitter_setting) {
    var emitter = mode.emitter_setting;
    draw_set_alpha(0.75);
    draw_set_colour(c_black);
    
    if (mode.emitter_first_corner) {
        if (Controller.mouse_left) {
            mode.emitter_first_corner = false;
            emitter.region_x1 = mouse_x_view;
            emitter.region_y1 = mouse_y_view;
        }
        
        draw_rectangle(0, 0, ww, hh, false);
    } else {
        if (Controller.mouse_left) {
            mode.emitter_first_corner = false;
            emitter.region_x2 = mouse_x_view;
            emitter.region_y2 = mouse_y_view;
        }
        
        var xmn = min(emitter.region_x1, emitter.region_x2);
        var ymn = min(emitter.region_y1, emitter.region_y2);
        var xmx = max(emitter.region_x1, emitter.region_x2);
        var ymx = max(emitter.region_y1, emitter.region_y2);
        
        draw_rectangle(0, 0, xmn, hh, false);
        draw_rectangle(xmn + 1, 0, xmx, ymn, false);
        draw_rectangle(xmn + 1, ymx, xmx, hh, false);
        draw_rectangle(xmx, 0, ww, hh, false);
        
        if (Controller.release_left) {
            part_system_automatic_update(mode.system, mode.system_auto_update);
            part_emitter_region(Stuff.particle.system, emitter.emitter, emitter.region_x1, emitter.region_x2, emitter.region_y1, emitter.region_y2, emitter.region_shape, emitter.region_distribution);
            dialog_destroy();
            ui_particle_emitter_select(mode.ui.t_emitter.list);
            mode.emitter_setting = noone;
        }
    }
    
    draw_set_alpha(1);
    draw_set_colour(c_white);
}