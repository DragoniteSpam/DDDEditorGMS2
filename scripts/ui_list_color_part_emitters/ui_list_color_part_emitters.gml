/// @param UIList
/// @param index

var list = argument0;
var index = argument1;

var emitter = list.entries[| index];
return emitter.streaming ? c_black : c_gray;