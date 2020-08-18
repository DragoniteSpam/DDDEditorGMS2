/// @param Dialog
function dialog_data_type_disable(argument0) {

	var dialog = argument0;

	// turns off all of the UI elements associated with properties of data

	dialog.el_data_name.interactive = false;
	dialog.el_add_p.interactive = false;
	dialog.el_remove_p.interactive = false;

	dialog.el_property_name.interactive = false;
	dialog.el_property_type.interactive = false;
	dialog.el_property_ext_type.interactive = false;
	dialog.el_property_type_guid.enabled = false;
	dialog.el_property_size.interactive = false;
	dialog.el_property_size_can_be_zero.interactive = false;
	dialog.el_property_min.interactive = false;
	dialog.el_property_max.interactive = false;
	dialog.el_property_char_limit.interactive = false;
	dialog.el_property_scale.interactive = false;

	dialog.el_property_scale.interactive = false;

	dialog.el_property_min.enabled = false;
	dialog.el_property_char_limit.enabled = false;
	dialog.el_property_max.enabled = false;
	dialog.el_property_scale.enabled = false;

	dialog.el_property_default_code.enabled = false;
	dialog.el_property_default_string.enabled = false;
	dialog.el_property_default_real.enabled = false;
	dialog.el_property_default_int.enabled = false;
	dialog.el_property_default_bool.enabled = false;
	dialog.el_property_default_na.enabled = false;
	dialog.el_property_default_code.editor_handle = noone;   // if something's open, we're just going to disown it


}
