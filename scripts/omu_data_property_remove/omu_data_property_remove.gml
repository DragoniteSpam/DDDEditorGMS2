/// @param UIButton

var button = argument0;

if (button.root.selected_property) {
    var data = button.root.selected_data;
    var index = ds_list_find_index(data.properties, button.root.selected_property);
    ds_list_delete(data.properties, index);
    
    if (data.type == DataTypes.DATA) {
        var instances = data.instances;
        for (var i = 0; i < ds_list_size(instances); i++) {
            ds_list_destroy(instances[| i].values[| index]);
            ds_list_delete(instances[| i].values, index);
        }
    }
    
    ui_list_deselect(button.root.el_list_p);
    button.interactive = false;
    button.root.el_move_up.interactive = false;
    button.root.el_move_down.interactive = false;
}