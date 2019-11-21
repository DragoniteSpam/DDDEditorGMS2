/// @param UIButton

var button = argument0;
var base_dialog = button.root;
var entity = base_dialog.entity;
var selection = ui_list_selection(base_dialog.el_list);

var dialog = dialog_create_select_data_types_ext(button, entity.generic_data[| selection].type, uivc_radio_entity_data_type_ext);