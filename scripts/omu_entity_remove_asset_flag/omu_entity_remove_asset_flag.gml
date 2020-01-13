/// @param UIButton

var button = argument0;
var list = button.root.el_list;
var index = ui_list_selection(list);

ds_list_delete(Stuff.all_asset_flags, index);

if (index >= ds_list_size(Stuff.all_asset_flags)) {
    ui_list_deselect(list);
    ui_list_select(list, --index);
}

ui_input_set_value(button.root.el_name, Stuff.all_asset_flags[| index]);

button.root.el_add.interactive = ds_list_size(Stuff.all_asset_flags) < 32;
button.interactive = ds_list_size(Stuff.all_asset_flags) > 1;
button.root.el_name.interactive = ds_list_size(Stuff.all_asset_flags) > 0;