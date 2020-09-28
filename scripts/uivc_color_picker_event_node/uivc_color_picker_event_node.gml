function uivc_color_picker_event_node(picker) {
    var node = picker.root.node;
    var index = picker.root.index;
    node.custom_data[| index][| 0] = picker.value;
}