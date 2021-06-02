/// @param UIColorPicker
function uivc_input_entity_data_color(argument0) {

    var picker = argument0;
    var entity = picker.root.entity;
    var selection = ui_list_selection(picker.root.el_list);
    var data = entity.generic_data[selection];

    data.value_color = picker.value;


}
