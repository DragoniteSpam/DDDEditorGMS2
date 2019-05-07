/// @description  void omu_event_custom_data_select(UIThing);
/// @param UIThing

var dialog=dialog_create_data_data_select(argument0);
dialog.el_confirm.onmouseup=dc_event_custom_property_set_data;
