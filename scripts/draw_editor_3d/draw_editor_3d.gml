/// @param EditorModeMap

var mode = argument0;

var map = Stuff.map.active_map;
var map_contents = map.contents;

draw_clear(c_black);

gpu_set_zwriteenable(true);
gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);
// this used to be turned off for 2D maps and there was a comment saying weird things
// would happen, but it was causing layering issues and i havent seen anything bad
// happen from turning it off yet
gpu_set_ztestenable(true);

draw_set_color(c_white);

var camera = view_get_camera(view_current);

if (map.is_3d) {
    var vw = view_get_wport(view_current);
    var vh = view_get_hport(view_current);
    camera_set_view_mat(camera, matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup));
    camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-mode.fov, -vw / vh, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
} else {
    var cwidth = camera_get_view_width(camera);
    var cheight = camera_get_view_height(camera);
    camera_set_view_mat(camera, matrix_build_lookat(mode.x, mode.y, 16000,  mode.x, mode.y, -16000, 0, 1, 0));
    camera_set_proj_mat(camera, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
    camera_apply(camera);
}

graphics_draw_water();

// anything in the world

shader_set(shd_default);

// this will need to be dynamic at some point
var tex = Stuff.setting_view_texture ? sprite_get_texture(get_active_tileset().master, 0) : sprite_get_texture(b_tileset_textureless, 0);

if (map_contents.frozen && Stuff.setting_view_entities) {
    vertex_submit(map_contents.frozen, pr_trianglelist, tex);
}
if (map_contents.frozen_wire && Stuff.setting_view_entities && Stuff.setting_view_wireframe) {
    vertex_submit(map_contents.frozen_wire, pr_linelist, -1);
}

for (var i = 0; i < ds_list_size(map_contents.batch_data); i++) {
    var data = map_contents.batch_data[| i];
    if (Stuff.setting_view_entities) {
        vertex_submit(data[? "vertex"], pr_trianglelist, tex);
    }
    if (Stuff.setting_view_wireframe) {
        vertex_submit(data[? "wire"], pr_linelist, -1);
    }
}

for (var i = 0; i < ds_list_size(map_contents.batch_in_the_future); i++) {
    var ent = map_contents.batch_in_the_future[| i];
    script_execute(ent.render, ent);
    // batchable entities don't make use of move routes, so don't bother
}

var list_routes = ds_list_create();       // [buffer, x, y, z, extra?, extra x, extra y, extra z], positions are absolute

for (var i = 0; i < ds_list_size(map_contents.dynamic); i++) {
    var ent = map_contents.dynamic[| i];
    script_execute(ent.render, ent);
    for (var j = 0; j < MAX_VISIBLE_MOVE_ROUTES; j++) {
        var route = guid_get(ent.visible_routes[j]);
        if (route && route.buffer) {
            ds_list_add(list_routes, [route.buffer, (ent.xx + 0.5) * TILE_WIDTH, (ent.yy + 0.5) * TILE_HEIGHT, (ent.zz + 0.5) * TILE_DEPTH,
                route.extra, route.extra_xx, route.extra_yy, route.extra_zz]);
        }
    }
}

shader_reset();
gpu_set_cullmode(cull_noculling);

// because apparently you can't do color with a passthrough shader even though it has a color attribute
for (var i = 0; i < ds_list_size(list_routes); i++) {
    var data = list_routes[| i];
    transform_set(data[@ 1], data[@ 2], data[@ 3], 0, 0, 0, 1, 1, 1);
    vertex_submit(data[@ 0], pr_linestrip, -1);
    if (data[@ 4]) {
        transform_set(0, 0, 0, 90, 0, point_direction(mode.x, mode.y, data[@ 1] + data[@ 5], data[@ 2] + data[@ 6]) - 90, 1, 1, 1);
        transform_add(data[@ 1] + data[@ 5], data[@ 2] + data[@ 6], data[@ 3] + data[@ 7], 0, 0, 0, 1, 1, 1);
        draw_sprite_ext(spr_plus_minus, 0, 0, 0, 0.25, 0.25, 0, c_lime, 1);
    }
}

if (Stuff.setting_view_grid) {
    transform_set(0, 0, Stuff.map.edit_z * TILE_DEPTH + 0.5, 0, 0, 0, 1, 1, 1);
    vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
    transform_reset();
    transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);
    vertex_submit(Stuff.graphics.axes, pr_linelist, -1);
}

// tried using ztestenable for this - didn't look good. at all.
for (var i = 0; i < ds_list_size(mode.selection); i++) {
    var sel = mode.selection[| i];
    script_execute(sel.render, sel);
}

if (Stuff.setting_view_zones) {
    // zones
    for (var i = 0; i < ds_list_size(map_contents.all_zones); i++) {
        zone_render_rectangle(map_contents.all_zones[| i]);
    }
}

ds_list_destroy(list_routes);

if (Stuff.game_starting_map == Stuff.map.active_map.GUID) {
    transform_set(0, 0, 0, 0, 0, Stuff.direction_lookup[Stuff.game_starting_direction], 1, 1, 1);
    transform_add((Stuff.game_starting_x + 0.5) * TILE_WIDTH, (Stuff.game_starting_y + 0.5) * TILE_HEIGHT, Stuff.game_starting_z * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
    vertex_submit(Stuff.graphics.basic_cage, pr_trianglelist, -1);
}

transform_reset();

// overlay stuff - draw_camera_controls_overlay exists, but i'd actually rather not use it for this
gpu_set_ztestenable(false);
var cwidth = camera_get_view_width(camera);
var cheight = camera_get_view_height(camera);
camera_set_view_mat(camera, matrix_build_lookat(cwidth / 2, cheight / 2, 16000,  cwidth / 2, cheight / 2, -16000, 0, 1, 0));
camera_set_proj_mat(camera, matrix_build_projection_ortho(-cwidth, cheight, CAMERA_ZNEAR, CAMERA_ZFAR));
camera_apply(camera);

#region height controls
// base bar
var height = clamp(24 * mode.active_map.zz, 64, 640);
var sw = sprite_get_width(spr_vertical_bar);
var sh = sprite_get_height(spr_vertical_bar);
var bw = sprite_get_width(spr_plus_minus_button);
var bh = sprite_get_height(spr_plus_minus_button);
var yy_start = 64 + bh;
var yy_end = 64 + height - bh;
draw_sprite_stretched(spr_vertical_bar, 0, 32 - sw / 2, 64, sw, height);

// bar notches
var notch_count = min(power(2, floor(log2(max(mode.active_map.zz, 2)))), 16);
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
var interval = slider_length / (mode.active_map.zz - 1);
var slider_y = 64 + height - bh - mode.edit_z * interval;
var slw = sprite_get_width(spr_drag_handle_vertical);
var slh = sprite_get_height(spr_drag_handle_vertical);
var overlap_slider = mouse_within_rectangle_view(32 - slw / 2, slider_y - slh / 2, 32 + slw / 2, slider_y + slh / 2);
draw_sprite_ext(spr_drag_handle_vertical, 0, 32, slider_y, 1, 1, 0, overlap_slider ? c_ui_select : c_white, 1);

// interactions
var overlap_interval = mouse_within_rectangle_view(32 - slw / 2, 64, 32 + slw / 2, 64 + height);

if (overlap_plus) {
    if (mouse_check_button_pressed(mb_left)) {
        mode.edit_z = min(++mode.edit_z, mode.active_map.zz - 1);
    }
    mode.mouse_over_ui = true;
} else if (overlap_minus) {
    if (mouse_check_button_pressed(mb_left)) {
        mode.edit_z = max(--mode.edit_z, 0);
    }
    mode.mouse_over_ui = true;
} else if (overlap_interval) {
    if (mouse_check_button(mb_left)) {
        var f = clamp((yy_end - mouse_y_view) / (yy_end - yy_start), 0, 1);
        mode.edit_z = round(normalize_correct(f, 0, mode.active_map.zz - 1, 0, 1));
    }
    mode.mouse_over_ui = true;
}
#endregion