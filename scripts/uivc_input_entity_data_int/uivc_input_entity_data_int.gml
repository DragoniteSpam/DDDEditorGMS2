/// @param UIInput
function uivc_input_entity_data_int(argument0) {

    var input = argument0;
    var entity = input.root.entity;
    var selection = ui_list_selection(input.root.el_list);
    var data = entity.generic_data[selection];

    data.value = real(input.value);


}
