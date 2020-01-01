/// @param UIList
/// @param index

var list = argument0;
var index = argument1;
var file_data = list.entries[| index];

return file_data.internal_name + Stuff.setting_asset_extension_map[file_data.extension];