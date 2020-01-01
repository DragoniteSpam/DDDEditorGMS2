/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var data = list.entries[| index];

return data[0] + Stuff.setting_asset_extension_map[data[1]];