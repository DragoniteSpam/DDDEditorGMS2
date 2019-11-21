/// @param UIButton

var button = argument0;
var entity = button.root.entity;
var selection = ui_list_selection(button.root.el_list);

if (is_clamped(selection, 0, ds_list_size(entity.generic_data) - 1)) {
    var data = entity.generic_data[| selection];
    ds_list_delete(entity.generic_data, selection);
    instance_activate_object(data);
    instance_destroy(data);
}