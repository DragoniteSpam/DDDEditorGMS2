/// @param Dialog

var value = real(argument0.root.root.value);
var times = ds_list_size(Stuff.all_global_variables) - value;

repeat (times) {
    ds_list_pop(Stuff.all_global_variables);
}

var base_dialog = argument0.root.root.root;
if (value <= ui_list_selection(base_dialog.el_list)) {
    ui_list_deselect(base_dialog.el_list);
}

while (ds_list_size(base_dialog.el_list.entries) > value) {
    ds_list_pop(base_dialog.el_list.entries);
}

ui_list_reset_view(base_dialog.el_list);

dialog_destroy();