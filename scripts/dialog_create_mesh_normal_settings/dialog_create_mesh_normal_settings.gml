/// @param Dialog
/// @param selected-meshes
function dialog_create_mesh_normal_settings(argument0, argument1) {

	var root = argument0;
	var selection = argument1;
	var mode = Stuff.mesh_ed;

	var dw = 320;
	var dh = 320;

	var dg = dialog_create(dw, dh, "Normals", dialog_default, dc_close_no_questions_asked, root);
	dg.selection = selection;

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

	var el_none = create_button(c1x, yy, "Remove Normals", ew, eh, fa_center, omu_meshes_normals_remove, dg);
	el_none.tooltip = "Re-initialize all normals (to 0, 0, 1), so that the entire model is lit the same way.";
	yy += el_none.height + spacing;

	var el_flat = create_button(c1x, yy, "Set Flat Normals", ew, eh, fa_center, omu_meshes_normals_flat, dg);
	el_flat.tooltip = "Set the normals of each vertex to the normals of their triangle.";
	yy += el_flat.height + spacing;

	var el_smooth = create_button(c1x, yy, "Set Smooth Normals", ew, eh, fa_center, omu_meshes_normals_smooth, dg);
	el_smooth.tooltip = "Weigh the normals of each vertex based on the angle of their surrounding triangles, if the angle between them is less than the specified threshold.";
	yy += el_smooth.height + spacing;

	var el_smooth_threshold = create_input(c1x, yy, "Threshold:", ew, eh, omu_meshes_normals_smooth_threshold, Stuff.setting_normal_threshold, "angle", validate_double, 0, 360, 5, vx1, vy1, vx2, vy2, dg);
	el_smooth_threshold.tooltip = "The threshold which the angle between two triangles must be less than in order for their vertix normals to be smoothed. (A threshold of zero is the same as flat shading.)";
	yy += el_smooth_threshold.height + spacing;

	var b_width = 128;
	var b_height = 32;
	var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

	ds_list_add(dg.contents,
	    el_none, el_flat, el_smooth, el_smooth_threshold,
	    el_confirm
	);

	return dg;


}
