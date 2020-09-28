/// @param UIInput
function uivc_mesh_collision_cell_y(argument0) {

    var input = argument0;
    input.root.yy = real(input.value);
    input.root.el_y.value = input.root.yy / max(input.value_upper, 1);

    var mesh = input.root.mesh;
    var slice = mesh.collision_flags[# input.root.xx, input.root.yy];
    input.root.el_collision_triggers.value = slice[@ input.root.zz];


}
