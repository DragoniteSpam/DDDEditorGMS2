/// @param UIInput

var input = argument0;
input.root.xx = real(input.value);
input.root.el_x.value = input.root.xx / max(input.value_upper, 1);

var mesh = input.root.mesh;
var slice = mesh.collision_flags[# input.root.xx, input.root.yy];
input.root.el_collision_triggers.value = slice[@ input.root.zz];