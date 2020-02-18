/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var mesh = list.entries[| index];

var prefix = "";
switch (mesh.marker) {
    case 0: break;
    case 1: prefix = "*"; break;
}

return prefix + mesh.name;