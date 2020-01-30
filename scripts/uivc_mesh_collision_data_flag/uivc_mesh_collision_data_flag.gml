/// @param UIBitfieldOption

var option = argument0;
var mesh = option.root.root.mesh;
var slice = mesh.collision_flags[# option.root.root.xx, option.root.root.yy];
option.root.value = option.root.value ^ (1 << option.value);

slice[@ option.root.root.zz] = option.root.value;