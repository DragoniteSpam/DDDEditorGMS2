/// @param Dialog
/// @param DataMesh

var root = argument[0];
var mesh = argument[1];

var dw = 1280;
var dh = 560;

var dg = dialog_create(dw, dh, "Mesh collision data: " + mesh.name, dialog_default, dc_close_no_questions_asked, root);
dg.mesh = mesh;
dg.xx = 0;
dg.yy = 0;
dg.zz = 0;

var columns = 4;
var spacing = 16;
var ew = (dw - spacing * 2) / columns;
var eh = 24;

var ew = (dw - columns * spacing * 2) / columns;
var eh = 24;

var c1 = dw * 0 / columns + spacing;
var c2 = dw * 1 / columns + spacing;
var c3 = dw * 2 / columns + spacing;
var c4 = dw * 3 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var yy = 64;
var yy_base = yy;

var color_active = 0x9999cc;
var color_inactive = c_white;

var el_x_input = create_input(c1, yy, "X:", ew, eh, uivc_mesh_collision_cell_x, 0, "", validate_int, 0, mesh.xmax - mesh.xmin, 3, vx1, vy1, vx2, vy2, dg);
dg.el_x_input = el_x_input;

yy = yy + el_x_input.height + spacing;

var el_x = create_progress_bar(c1, yy, ew, eh, uivc_mesh_collision_cell_x_slider, 4, 0, dg);
dg.el_x = el_x;

yy = yy + el_x.height + spacing;

var el_y_input = create_input(c1, yy, "Y:", ew, eh, uivc_mesh_collision_cell_y, 0, "", validate_int, 0, mesh.ymax - mesh.ymin, 3, vx1, vy1, vx2, vy2, dg);
dg.el_y_input = el_y_input;

yy = yy + el_y_input.height + spacing;

var el_y = create_progress_bar(c1, yy, ew, eh, uivc_mesh_collision_cell_y_slider, 4, 0, dg);
dg.el_y = el_y;

yy = yy + el_y.height + spacing;

var el_z_input = create_input(c1, yy, "Z:", ew, eh, uivc_mesh_collision_cell_z, 0, "", validate_int, 0, mesh.zmax - mesh.zmin, 3, vx1, vy1, vx2, vy2, dg);
dg.el_z_input = el_z_input;

yy = yy + el_z_input.height + spacing;

var el_z = create_progress_bar(c1, yy, ew, eh, uivc_mesh_collision_cell_z_slider, 4, 0, dg);
dg.el_z = el_z;

yy = yy + el_z.height + spacing;

yy = yy_base;

var el_collision_flags = create_bitfield(c3, yy, "Collision Triggers", ew, eh, null, 0, dg);

for (var i = 0; i < 32; i++) {
    var field_xx = (i >= 16) ? ew : 0;
    // Each element will be positioned based on the one directly above it, so you
    // only need to move them up once otherwise they'll keep moving up the screen
    var field_yy = (i == 16) ? -(eh * 16) : 0;
    var label = (i >= ds_list_size(Stuff.all_collision_triggers)) ? "<" + string(i) + ">" : Stuff.all_collision_triggers[| i];
    create_bitfield_options_vertical(el_collision_flags, [create_bitfield_option_data(i, ui_render_bitfield_option_text, null, label, -1, 0, ew / 2, spacing / 2, field_xx, field_yy, color_active, color_inactive)]);
}

create_bitfield_options_vertical(el_collision_flags, [
    create_bitfield_option_data(i, ui_render_bitfield_option_text, null, "All", -1, 0, ew / 2, spacing / 2, 0, 0, color_active, color_inactive),
    create_bitfield_option_data(i, ui_render_bitfield_option_text, null, "None", -1, 0, ew / 2, spacing / 2, ew, -eh, color_active, color_inactive),
]);

el_collision_flags.tooltip = "Collision triggers; each cell occupied by a mesh can have its collision data toggled on or off";

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
    el_collision_flags,
    el_confirm
);

return dg;