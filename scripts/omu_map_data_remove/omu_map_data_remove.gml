/// @param UIButton

var button = argument0;
var base_dialog = button.root;
var map = Stuff.map.active_map;
var selection = ui_list_selection(base_dialog.el_list);

if (!ds_list_empty(map.generic_data)) {
    if (is_clamped(selection, 0, ds_list_size(map.generic_data) - 1)) {
        var data = map.generic_data[| selection];
        ds_list_delete(map.generic_data, selection);
        instance_activate_object(data);
        instance_destroy(data);
    }
    
    // enable by type whatever is currently selected; if the last entry in the
    // list has been deleted, then disable all of the needed buttons
    var last = ds_list_size(map.generic_data) - 1;
    dialog_entity_data_type_disable(base_dialog);
    
    if (ds_list_empty(map.generic_data)) {
        ui_list_deselect(base_dialog.el_list);
    } else {
        if (!is_clamped(selection, 0, last)) {
            ui_list_deselect(base_dialog.el_list);
            base_dialog.el_list.selected_entries[? last] = true;
        }
        dialog_entity_data_enable_by_type(base_dialog);
    }
}