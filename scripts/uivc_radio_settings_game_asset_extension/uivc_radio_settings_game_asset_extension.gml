/// @param UIRadioArrayOption

var option = argument0;
var list = option.root.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    var file_data = list.entries[| selection];
    file_data.extension = option.value;
}