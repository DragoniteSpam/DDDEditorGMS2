/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var file_data = list.entries[| index];

return file_data.compressed ? c_blue : c_black;