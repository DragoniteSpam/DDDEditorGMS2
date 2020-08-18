/// @param UIButton
function uivc_mesh_preview_reset(argument0) {

	var button = argument0;
	var mesh = button.root.mesh;

	Stuff.mesh_x = 0;
	Stuff.mesh_y = 0;
	Stuff.mesh_z = 0;
	Stuff.mesh_xrot = 0;
	Stuff.mesh_yrot = 0;
	Stuff.mesh_zrot = 0;
	Stuff.mesh_scale = 1;
	mesh.preview_index = 0;

	ui_input_set_value(button.root.el_control_x, string(Stuff.mesh_x));
	ui_input_set_value(button.root.el_control_y, string(Stuff.mesh_y));
	ui_input_set_value(button.root.el_control_z, string(Stuff.mesh_z));
	ui_input_set_value(button.root.el_control_rot_x, string(Stuff.mesh_xrot));
	ui_input_set_value(button.root.el_control_rot_y, string(Stuff.mesh_yrot));
	ui_input_set_value(button.root.el_control_rot_z, string(Stuff.mesh_zrot));
	ui_input_set_value(button.root.el_control_scale, string(Stuff.mesh_scale));
	ui_input_set_value(button.root.el_controls_index, string(mesh.preview_index));
	var bsize = buffer_get_size(mesh.submeshes[| mesh.preview_index].buffer);
	button.root.el_stats_kb.text = "    Size: " + string_comma(bsize) + " bytes";
	button.root.el_stats_vertices.text = "    Vertices: " + string(bsize / VERTEX_SIZE);
	button.root.el_stats_triangles.text = "    Triangles: " + string(bsize / VERTEX_SIZE / 3);


}
