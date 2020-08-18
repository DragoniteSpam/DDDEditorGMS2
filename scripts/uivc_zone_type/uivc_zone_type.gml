/// @param UIList
function uivc_zone_type(argument0) {

	var list = argument0;

	Stuff.setting_selection_zone_type = ui_list_selection(list);
	setting_set("Selection", "zone-type", Stuff.setting_selection_zone_type);


}
