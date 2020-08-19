/// @param UIColorPickerInput
function uivc_color_picker_event_node(argument0) {

    var picker = argument0;
    var node = picker.root.node;
    var index = picker.root.index;

    // @gml update
    var data_list = node.custom_data[| index];
    data_list[| 0] = picker.value;


}
