/// @param Dialog
/// @param DataMesh

var root = argument[0];
var mesh = argument[1];

var dw = 1440;
var dh = 560;

var dg = dialog_create(dw, dh, "Mesh collision data: " + mesh.name, dialog_default, dc_close_no_questions_asked, root);
dg.mesh = mesh;
dg.xx = 0;
dg.yy = 0;
dg.zz = 0;

var columns = 5;
var spacing = 16;
var ew = (dw - spacing * 2) / columns;
var eh = 24;

var ew = (dw - columns * spacing * 2) / columns;
var eh = 24;

var c1 = dw * 0 / columns + spacing;
var c2 = dw * 1 / columns + spacing;
var c3 = dw * 2 / columns + spacing;
var c4 = dw * 3 / columns + spacing;
var c5 = dw * 4 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;
var yy_base = yy;

var color_active = c_ui_select;
var color_inactive = c_white;

#region numerical inputs and sliders
var el_x_input = create_input(c1, yy, "X:", ew, eh, uivc_mesh_collision_cell_x, 0, "", validate_int, 0, max(mesh.xmax - mesh.xmin - 1, 0), 3, vx1, vy1, vx2, vy2, dg);
el_x_input.value_default = string(el_x_input.value_upper);
dg.el_x_input = el_x_input;

yy = yy + el_x_input.height + spacing;

var el_x = create_progress_bar(c1, yy, ew, eh, uivc_mesh_collision_cell_x_slider, 4, 0, dg);
dg.el_x = el_x;

yy = yy_base;

var el_y_input = create_input(c2, yy, "Y:", ew, eh, uivc_mesh_collision_cell_y, 0, "", validate_int, 0, max(mesh.ymax - mesh.ymin - 1, 0), 3, vx1, vy1, vx2, vy2, dg);
el_y_input.value_default = string(el_y_input.value_upper);
dg.el_y_input = el_y_input;

yy = yy + el_y_input.height + spacing;

var el_y = create_progress_bar(c2, yy, ew, eh, uivc_mesh_collision_cell_y_slider, 4, 0, dg);
dg.el_y = el_y;

yy = yy_base;

var el_z_input = create_input(c3, yy, "Z:", ew, eh, uivc_mesh_collision_cell_z, 0, "", validate_int, 0, max(mesh.zmax - mesh.zmin - 1, 0), 3, vx1, vy1, vx2, vy2, dg);
el_z_input.value_default = string(el_z_input.value_upper);
dg.el_z_input = el_z_input;

yy = yy + el_z_input.height + spacing;

var el_z = create_progress_bar(c3, yy, ew, eh, uivc_mesh_collision_cell_z_slider, 4, 0, dg);
dg.el_z = el_z;

yy = yy + el_z.height + spacing;

var yy_base_c1 = yy;

var el_alpha_text = create_text(c3, yy, "Preview Alpha", ew, eh, fa_left, ew, dg);

yy = yy + el_z_input.height + spacing;

var el_alpha = create_progress_bar(c3, yy, ew, eh, null, 4, 0, dg);
el_alpha.value = 0.5;
dg.el_alpha = el_alpha;

yy = yy + el_z.height + spacing;

var yy_base_c3 = yy;
#endregion

yy = yy_base;

#region collision triggers
var slice = mesh.collision_flags[# dg.xx, dg.yy];
var default_value = slice[@ dg.zz];
var el_collision_triggers = create_bitfield(c4, yy, "Collision Triggers", ew, eh, default_value, dg);
dg.el_collision_triggers = el_collision_triggers;

for (var i = 0; i < 32; i++) {
    var field_xx = (i >= 16) ? ew : 0;
    // Each element will be positioned based on the one directly above it, so you
    // only need to move them up once otherwise they'll keep moving up the screen
    var field_yy = (i == 16) ? -(eh * 16) : 0;
    var label = (i >= ds_list_size(Stuff.all_collision_triggers)) ? "<" + string(i) + ">" : Stuff.all_collision_triggers[| i];
    create_bitfield_options_vertical(el_collision_triggers, [create_bitfield_option_data(i, uivc_mesh_collision_render_data_flag, uivc_mesh_collision_data_flag, label, -1, 0, ew / 2, spacing / 2, field_xx, field_yy, color_active, color_inactive)]);
}

create_bitfield_options_vertical(el_collision_triggers, [
    create_bitfield_option_data(i, uivc_mesh_collision_render_data_flag_all, uivc_mesh_collision_data_flag_all, "All", -1, 0, ew / 2, spacing / 2, 0, 0, color_active, color_inactive),
    create_bitfield_option_data(i, uivc_mesh_collision_render_data_flag_none, uivc_mesh_collision_data_flag_none, "None", -1, 0, ew / 2, spacing / 2, ew, -eh, color_active, color_inactive),
]);

el_collision_triggers.tooltip = "Collision triggers; each cell occupied by a mesh can have its collision data toggled on or off.\n\nShaded cells are solid, while unshaded cells are passable.";
#endregion

#region preview(s)
yy = yy_base_c1;

var el_render = create_render_surface(c1, yy, ew * 2 + spacing, ew * 1.5, ui_render_surface_render_mesh_collision, ui_render_surface_control_mesh_collision, dg);

yy = yy_base_c3;

var el_render_grid = create_render_surface(c3, yy, ew, ew, ui_render_surface_render_mesh_collision_grid, ui_render_surface_control_mesh_collision_grid, dg);

yy = yy + el_render_grid.height + spacing;
#endregion

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_x_input,
    el_x,
    el_y_input,
    el_y,
    el_z_input,
    el_z,
    el_render,
    el_render_grid,
    el_alpha_text,
    el_alpha,
    el_collision_triggers,
    el_confirm
);

return dg;