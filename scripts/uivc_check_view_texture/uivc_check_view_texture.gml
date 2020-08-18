/// @param UICheckbox
function uivc_check_view_texture(argument0) {

	var checkbox = argument0;

	Stuff.setting_view_texture = checkbox.value;
	setting_set("View", "texture", Stuff.setting_view_texture);


}
