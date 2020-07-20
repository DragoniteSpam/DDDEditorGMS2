/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var mesh = Stuff.all_meshes[| index];

return (mesh.type == MeshTypes.SMF) ? c_red : c_black;