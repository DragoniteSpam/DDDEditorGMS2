/// @param Dialog
/// @param selected-meshes

var root = argument0;
var selection = argument1;
var mode = Stuff.mesh_ed;

var dw = 320;
var dh = 320;

var dg = dialog_create(dw, dh, "Normals", dialog_default, dc_close_no_questions_asked, root);
dg.selection = selection;
dg.threshold = 30;

var columns = 1;
var ew = dw / columns - 64;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var c1x = 0 * dw / columns + 32;
var spacing = 16;

var yy = 64;
var yy_base = 64;

var el_flat = create_button(c1x, yy, "Set Flat Normals", ew, eh, fa_center, null, dg);
yy += el_flat.height + spacing;

var el_smooth = create_button(c1x, yy, "Set Smooth Normals", ew, eh, fa_center, omu_meshes_normals_smooth, dg);
yy += el_smooth.height + spacing;

var el_smooth_threshold = create_input(c1x, yy, "Threshold:", ew, eh, omu_meshes_normals_smooth_threshold, dg.threshold, "angle", validate_double, 0, 360, 5, vx1, vy1, vx2, vy2, dg);
yy += el_smooth_threshold.height + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_flat, el_smooth, el_smooth_threshold,
    el_confirm
);

return dg;