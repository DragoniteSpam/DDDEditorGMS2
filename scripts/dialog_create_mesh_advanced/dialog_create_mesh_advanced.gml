/// @param Dialog
/// @param mesh

var root = argument0;
var mesh = argument1;

var dw = 640;
var dh = 480;

var dg = dialog_create(dw, dh, "Advanced Mesh Options: " + mesh.name, dialog_default, dc_close_no_questions_asked, root);

var ew = (dw - 64) / 2;
var eh = 24;

var col2 = dw / 2;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var spacing = 16;
var yy = 64;
var yy_base = yy;

var el_text_single = create_text(16, yy, mesh.name, ew, eh, fa_left, ew, dg);
yy = yy + el_text_single.height + spacing;
var el_auto_bounds = create_button(16, yy, "Auto-calculate bounds (grid: 32)", ew, eh, fa_center, null, dg);
yy = yy + el_auto_bounds.height + spacing;
var el_normal_flat = create_button(16, yy, "Normals: Flat", ew, eh, fa_center, null, dg);
yy = yy + el_normal_flat.height + spacing;
var el_normal_smooth = create_button(16, yy, "Normals: Smooth", ew, eh, fa_center, null, dg);
yy = yy + el_normal_smooth.height + spacing;
var el_up_axis = create_button(16, yy, "Rotate Up Axis", ew, eh, fa_center, null, dg);
yy = yy + el_up_axis.height + spacing;

yy = yy_base;

var el_text_all = create_text(col2 + 16, yy, "All", ew, eh, fa_left, ew, dg);
yy = yy + el_text_all.height + spacing;
var el_all_normal_flat = create_button(col2 + 16, yy, "Normals: Flat", ew, eh, fa_center, null, dg);
yy = yy + el_all_normal_flat.height + spacing;
var el_all_normal_smooth = create_button(col2 + 16, yy, "Normals: Smooth", ew, eh, fa_center, null, dg);
yy = yy + el_all_normal_smooth.height + spacing;

ds_list_add(dg.contents, el_text_single, el_auto_bounds, el_normal_flat, el_normal_smooth, el_up_axis,
    el_text_all, el_all_normal_flat, el_all_normal_smooth);

keyboard_string = "";

return dg;