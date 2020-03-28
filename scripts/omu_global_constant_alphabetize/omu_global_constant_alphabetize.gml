/// @param UIButton

var button = argument0;
var list = button.root.el_list;

var selection = list.entries[| ui_list_selection(list)];
ui_list_deselect(list);
ds_list_sort_name(list.entries);

for (var i = 0; i < ds_list_size(list.entries); i++) {
    if (list.entries[| i] == selection) {
        ui_list_select(list, i);
        break;
    }
}