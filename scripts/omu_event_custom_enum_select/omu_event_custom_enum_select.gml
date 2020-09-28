/// @param UIButton
function omu_event_custom_enum_select(argument0) {

    var button = argument0;
    var dialog = dialog_create_data_enum_select(button);
    dialog.el_confirm.onmouseup = dc_event_custom_property_set_enum;


}
