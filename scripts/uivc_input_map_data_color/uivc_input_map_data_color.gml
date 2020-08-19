/// @param UIColorPicker
function uivc_input_map_data_color(argument0) {

    var picker = argument0;
    var map = Stuff.map.active_map;
    var selection = ui_list_selection(picker.root.el_list);
    var data = map.generic_data[| selection];

    data.value_color = picker.value;


}
