/// @param Dialog
/// @param mesh

var root = argument0;
var mesh = argument1;

var dw = 960;
var dh = 480;

var dg = dialog_create(dw, dh, "Advanced Mesh Options: " + mesh.name, dialog_default, dc_close_no_questions_asked, root);
dg.mesh = mesh;

var spacing = 16;
var columns = 3;
var ew = (dw - 32 * columns) / columns;
var eh = 24;

var col1_x = dw * 0 / 3 + spacing;
var col2_x = dw * 1 / 3 + spacing;
var col3_x = dw * 2 / 3 + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var el_text_single = create_text(col1_x, yy, mesh.name, ew, eh, fa_left, ew, dg);
yy = yy + el_text_single.height + spacing;
var el_auto_bounds = create_button(col1_x, yy, "Auto-calculate bounds (grid: 32)", ew, eh, fa_center, omu_mesh_auto_bounds, dg);
yy = yy + el_auto_bounds.height + spacing;
var el_normal_flat = create_button(col1_x, yy, "Normals: Flat", ew, eh, fa_center, omu_mesh_normal_flat, dg);
yy = yy + el_normal_flat.height + spacing;
var el_normal_smooth = create_button(col1_x, yy, "Normals: Smooth", ew, eh, fa_center, omu_mesh_normal_smooth, dg);
yy = yy + el_normal_smooth.height + spacing;
var el_up_axis = create_button(col1_x, yy, "Rotate Up Axis", ew, eh, fa_center, omu_mesh_rotate_axis, dg);
yy = yy + el_up_axis.height + spacing;

yy = yy_base;

var el_markers = create_list(col2_x, yy, "Extra Mesh Markers", "", ew, eh, 8, uivc_list_mesh_markers, true, dg);
create_list_entries(el_markers, "Particle Mesh");
el_markers.select_toggle = true;
for (var i = 0; i < 32; i++) {
    if (mesh.marker & (1 << i)) {
        ui_list_select(el_markers, i);
    }
}
yy = yy + ui_get_list_height(el_markers) + spacing;

yy = yy_base;

var el_text_all = create_text(col3_x, yy, "All Meshes", ew, eh, fa_left, ew, dg);
yy = yy + el_text_all.height + spacing;
var el_all_normal_flat = create_button(col3_x, yy, "Normals: Flat", ew, eh, fa_center, null, dg);
yy = yy + el_all_normal_flat.height + spacing;
var el_all_normal_smooth = create_button(col3_x, yy, "Normals: Smooth", ew, eh, fa_center, null, dg);
yy = yy + el_all_normal_smooth.height + spacing;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_text_single,
    el_auto_bounds,
    el_normal_flat,
    el_normal_smooth,
    el_up_axis,
    el_markers,
    el_text_all,
    el_all_normal_flat,
    el_all_normal_smooth,
    el_confirm
);

return dg;