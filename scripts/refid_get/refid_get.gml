/// @param data
/// @param refid
/// @param [map]

var refid = argument[0];
var map = (argument_count > 1 && argument[1] != undefined) ? argument[1] : Stuff.map.active_map;

return map.contents.refids[? refid] ? map.contents.refids[? refid] : noone;