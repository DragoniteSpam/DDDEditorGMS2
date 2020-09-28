/// @param UIButton
function omu_datadata_select_type(argument0) {

    var button = argument0;
    var base_dialog = button.root;

    dialog_create_select_data_types_ext(button, button.root.selected_property.type, uivc_radio_data_type_ext);


}
