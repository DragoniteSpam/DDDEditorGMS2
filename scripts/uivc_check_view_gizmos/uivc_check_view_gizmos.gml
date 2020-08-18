/// @param UICheckbox
function uivc_check_view_gizmos(argument0) {

	var checkbox = argument0;

	Stuff.setting_view_gizmos = checkbox.value;
	setting_set("View", "gizmos", Stuff.setting_view_gizmos);


}
