/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var file_data = list.entries[| index];

return index ? (file_data.internal_name + ".ddda") : "(default.dddd)";