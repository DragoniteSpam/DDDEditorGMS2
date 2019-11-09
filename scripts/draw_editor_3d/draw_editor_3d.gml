/// @param EditorModeMap

var mode = argument0;

var map = Stuff.map.active_map;
var map_contents = map.contents;

draw_clear(c_black);

if (!Stuff.mouse_3d_lock && mouse_within_view(view_3d) && !dialog_exists()) {
	if (map.is_3d) {
	    control_map_3d(mode);
	} else {
		control_map_2d(mode);
	}
}

gpu_set_zwriteenable(true);
gpu_set_cullmode(Stuff.setting_view_backface ? cull_noculling : cull_counterclockwise);
gpu_set_ztestenable(map.is_3d);        // this will make things rather odd with the wrong setting

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

// the autotile shader doesn't work yet and it's annoying
//shader_set(shd_default_autotile);
//shader_set_uniform_f_array(Stuff.shd_uniform_at_tex_offset, Stuff.shd_value_at_tex_offset);

shader_set(shd_default);

// this will need to be dynamic at some point
if (Stuff.setting_view_texture) {
    var tex = sprite_get_texture(get_active_tileset().master, 0);
} else {
    var tex = sprite_get_texture(b_tileset_textureless, 0);
}

if (map_contents.frozen && Stuff.setting_view_entities) {
    vertex_submit(map_contents.frozen, pr_trianglelist, tex);
}
if (map_contents.frozen_wire && Stuff.setting_view_entities && Stuff.setting_view_wireframe) {
    vertex_submit(map_contents.frozen_wire, pr_linelist, -1);
}

for (var i = 0; i < ds_list_size(map_contents.batches); i++) {
    if (Stuff.setting_view_entities) {
        vertex_submit(map_contents.batches[| i], pr_trianglelist, tex);
    }
    if (Stuff.setting_view_wireframe) {
        vertex_submit(map_contents.batches_wire[| i], pr_linelist, -1);
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

// "set" overwrites the previous transform anyway
transform_set(0, 0, 0.5, 0, 0, 0, 1, 1, 1);

if (Stuff.setting_view_grid) {
    vertex_submit(Stuff.graphics.grid, pr_linelist, -1);
}

// tried using ztestenable for this - didn't look good. at all.
for (var i = 0; i < ds_list_size(mode.selection); i++) {
    var sel = mode.selection[| i];
    script_execute(sel.render, sel);
}

ds_list_destroy(list_routes);

if (Stuff.game_starting_map == Stuff.map.active_map.GUID) {
	transform_set(0, 0, 0, 0, 0, Stuff.direction_lookup[Stuff.game_starting_direction], 1, 1, 1);
	transform_add((Stuff.game_starting_x + 0.5) * TILE_WIDTH, (Stuff.game_starting_y + 0.5) * TILE_HEIGHT, Stuff.game_starting_z * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
	vertex_submit(Stuff.graphics.basic_cage, pr_trianglelist, -1);
}

transform_reset();