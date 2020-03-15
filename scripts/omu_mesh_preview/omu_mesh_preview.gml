/// @param UIButton

var root = argument0;
var mesh = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

if (!mesh) {
    return;
}

var dw = 1280;
var dh = 760;

// todo cache the custom event and only commit the changes when you're done
var dg = dialog_create(dw, dh, "Mesh Preview", dialog_default, dc_close_no_questions_asked, root);
dg.mesh = mesh;

var columns = 4;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var col1_x = dw * 0 / columns + spacing;
var col2_x = dw * 1 / columns + spacing;
var col3_x = dw * 2 / columns + spacing;
var col4_x = dw * 3 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var b_width = 128;
var b_height = 32;

var n_slots = 20;

var yy = 64;

var el_surface = create_render_surface(col1_x, yy, 944, 624, ui_render_surface_render_mesh_preview, ui_render_surface_control_mesh_preview, dg);

var el_controls_title = create_text(col4_x, yy, "Controls", ew, eh, fa_left, ew, dg);
el_controls_title.color = c_blue;

yy += el_controls_title.height + spacing;

var el_control_x = create_input(col4_x, yy, "X:", ew, eh, uivc_mesh_preview_x, Stuff.mesh_x, "float", validate_double, -1000, 1000, 4, vx1, vy1, vx2, vy2, dg);
el_control_x.tooltip = "Left / right";
dg.el_control_x = el_control_x;

yy += el_control_x.height + spacing;

var el_control_y = create_input(col4_x, yy, "Y:", ew, eh, uivc_mesh_preview_y, Stuff.mesh_y, "float", validate_double, -1000, 1000, 4, vx1, vy1, vx2, vy2, dg);
el_control_x.tooltip = "Up / down";
dg.el_control_y = el_control_y;

yy += el_control_y.height + spacing;

var el_control_z = create_input(col4_x, yy, "Z:", ew, eh, uivc_mesh_preview_z, Stuff.mesh_z, "float", validate_double, -1000, 1000, 4, vx1, vy1, vx2, vy2, dg);
el_control_x.tooltip = "Shift + up / down";
dg.el_control_z = el_control_z;

yy += el_control_z.height + spacing;

// max value of 359.99 but only allowing 5 decimal places is rather clever, i like to think
var el_control_rot_x = create_input(col4_x, yy, "X Rotation:", ew, eh, uivc_mesh_preview_xrot, Stuff.mesh_xrot, "float", validate_double, 0, 359.99, 5, vx1, vy1, vx2, vy2, dg);
el_control_x.tooltip = "Control + left / right";
dg.el_control_rot_x = el_control_rot_x;

yy += el_control_rot_x.height + spacing;

var el_control_rot_y = create_input(col4_x, yy, "Y Rotation:", ew, eh, uivc_mesh_preview_yrot, Stuff.mesh_yrot, "float", validate_double, 0, 359.99, 5, vx1, vy1, vx2, vy2, dg);
el_control_x.tooltip = "Control + up / down";
dg.el_control_rot_y = el_control_rot_y;

yy += el_control_rot_y.height + spacing;

var el_control_rot_z = create_input(col4_x, yy, "Z Rotation:", ew, eh, uivc_mesh_preview_zrot, Stuff.mesh_zrot, "float", validate_double, 0, 359.99, 5, vx1, vy1, vx2, vy2, dg);
el_control_x.tooltip = "Shift + left / right";
dg.el_control_rot_z = el_control_rot_z;

yy += el_control_rot_z.height + spacing;

var el_control_scale = create_input(col4_x, yy, "Scale:", ew, eh, uivc_mesh_preview_scale, Stuff.mesh_scale, "float", validate_double, 0.1, 10, 3, vx1, vy1, vx2, vy2, dg);
el_control_scale.tooltip = "Alt + up / down";
dg.el_control_scale = el_control_scale;

yy += el_control_scale.height + spacing;

var el_controls_reset = create_button(col4_x, yy, "Reset", ew, eh, fa_center, uivc_mesh_preview_reset, dg);
el_controls_reset.tooltip = "Reset default settings for the preview window.";
dg.el_controls_reset = el_controls_reset;

yy += el_controls_reset.height + spacing;

var el_controls_index = create_input(col4_x, yy, "Submesh:", ew, eh, uivc_mesh_preview_index, mesh.preview_index, "int", validate_double, 0, ds_list_size(mesh.submeshes) -1 , 5, vx1, vy1, vx2, vy2, dg);
el_controls_index.tooltip = "There are " + string(ds_list_size(mesh.submeshes)) + " submeshes in " + mesh.name + ".";
dg.el_controls_index = el_controls_index;

yy += el_controls_index.height + spacing;

#region settings
var el_settings_title = create_text(col4_x, yy, "Settings", ew, eh, fa_left, ew, dg);
el_settings_title.color = c_blue;

yy += el_settings_title.height + spacing;

var el_settings_trans_rate = create_input(col4_x, yy, "Translation rate:", ew, eh, null, 2, "float", validate_double, 0, 8, 4, vx1, vy1, vx2, vy2, dg);
el_settings_trans_rate.tooltip = "Tiles per second.";
dg.el_settings_trans_rate = el_settings_trans_rate;

yy += el_settings_trans_rate.height + spacing;

var el_settings_rot_rate = create_input(col4_x, yy, "Rotation rate:", ew, eh, null, 120, "float", validate_double, 0, 720, 4, vx1, vy1, vx2, vy2, dg);
el_settings_rot_rate.tooltip = "Degrees per second.";
dg.el_settings_rot_rate = el_settings_rot_rate;

yy += el_settings_rot_rate.height + spacing;

var el_settings_scale_rate = create_input(col4_x, yy, "Scale rate:", ew, eh, null, 1, "float", validate_double, 0, 3, 4, vx1, vy1, vx2, vy2, dg);
el_settings_scale_rate.tooltip = "Whatever per second.";
dg.el_settings_scale_rate = el_settings_scale_rate;

yy += el_settings_scale_rate.height + spacing;
#endregion

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_close_no_questions_asked, dg);
dg.el_confirm = el_confirm;

ds_list_add(dg.contents,
    el_surface,
    el_controls_title,
    el_control_x,
    el_control_y,
    el_control_z,
    el_control_rot_x,
    el_control_rot_y,
    el_control_rot_z,
    el_control_scale,
    el_controls_reset,
    el_controls_index,
    el_settings_title,
    el_settings_trans_rate,
    el_settings_rot_rate,
    el_settings_scale_rate,
    el_confirm
);

return dg;