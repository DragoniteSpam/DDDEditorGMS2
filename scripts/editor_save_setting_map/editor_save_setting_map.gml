/// @param EditorModeMap
function editor_save_setting_map(argument0) {

	var map = argument0;

	setting_set("Map", "x", map.x);
	setting_set("Map", "y", map.y);
	setting_set("Map", "z", map.z);
	setting_set("Map", "xto", map.xto);
	setting_set("Map", "yto", map.yto);
	setting_set("Map", "zto", map.zto);
	setting_set("Map", "fov", map.fov);


}
