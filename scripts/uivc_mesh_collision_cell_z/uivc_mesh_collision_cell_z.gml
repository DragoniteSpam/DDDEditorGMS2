/// @param UIInput
function uivc_mesh_collision_cell_z(argument0) {

	var input = argument0;
	input.root.zz = real(input.value);
	input.root.el_z.value = input.root.zz / max(input.value_upper, 1);

	var mesh = input.root.mesh;
	var slice = mesh.collision_flags[# input.root.xx, input.root.yy];
	input.root.el_collision_triggers.value = slice[@ input.root.zz];


}
