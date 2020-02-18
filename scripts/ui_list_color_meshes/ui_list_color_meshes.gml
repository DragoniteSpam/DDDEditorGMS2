/// @param UIList
/// @param index

var list = argument0;
var index = argument1;

var mesh = list.entries[| index];

switch (mesh.type) {
    case MeshTypes.RAW: return c_black;
    case MeshTypes.SMF: return c_blue;
}