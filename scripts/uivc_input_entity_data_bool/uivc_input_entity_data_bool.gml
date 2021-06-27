/// @param UICheckbox
function uivc_input_entity_data_bool(argument0) {

    var checkbox = argument0;
    var entity = checkbox.root.entity;
    var selection = ui_list_selection(checkbox.root.el_list);
    var data = entity.generic_data[selection];

    data.value = checkbox.value;


}
