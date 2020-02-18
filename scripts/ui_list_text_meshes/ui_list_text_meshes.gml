/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var mesh = list.entries[| index];

var prefix = "";

if (mesh.marker & MeshMarkers.PARTICLE) {
    prefix = "* " + prefix;
}

return prefix + mesh.name;