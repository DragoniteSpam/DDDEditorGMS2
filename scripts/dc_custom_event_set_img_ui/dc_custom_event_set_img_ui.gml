/// @param UIButton

var button = argument0;

var list = button.root.el_list_main;
var selection = ui_list_selection(list);

if (selection + 1) {
    var data_list = list.node.custom_data[| list.property_index];
    data_list[| list.multi_index] = Stuff.all_graphic_ui[| selection].GUID;
}

dialog_destroy();