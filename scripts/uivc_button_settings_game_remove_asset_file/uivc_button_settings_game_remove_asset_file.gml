/// @param UIButton

var button = argument0;
var list_main = button.root.el_list;
var selection = ui_list_selection(list_main);

if (selection + 1 && ds_list_size(list_main.entries) > 0x01 && selection < ds_list_size(list_main.entries)) {
    var file_data = list_main.entries[| selection];
    ds_list_delete(list_main.entries, selection);
    instance_activate_object(file_data);
    instance_destroy(file_data);
    button.interactive = (ds_list_size(list_main.entries) > 0x01);
    button.root.el_add.interactive = (ds_list_size(list_main.entries) < 0xff);
}