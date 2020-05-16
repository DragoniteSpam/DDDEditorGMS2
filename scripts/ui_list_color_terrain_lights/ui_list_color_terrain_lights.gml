/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var light = list.entries[| index];

return (light.type == LightTypes.SPOT || light.type == LightTypes.NONE) ? c_gray : c_black;