/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var mesh = list.entries[| index];

var prefix = "";

if (mesh.marker & MeshMarkers.PARTICLE) {
    prefix = "(p)" + prefix;
}

if (ds_list_size(mesh.submeshes) == 1) {
    var suffix = " (" + string(buffer_get_size(mesh.submeshes[| 0].buffer) / VERTEX_SIZE / 3) + " triangles)";
} else {
    var suffix = " (" + ds_list_size(mesh.submeshes) + " submeshes)";
}

return prefix + mesh.name + suffix;