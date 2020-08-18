/// @param UICheckbox
function uivc_check_view_entities(argument0) {

	var checkbox = argument0;

	Stuff.setting_view_entities = checkbox.value;
	setting_set("View", "entities", Stuff.setting_view_entities);


}
