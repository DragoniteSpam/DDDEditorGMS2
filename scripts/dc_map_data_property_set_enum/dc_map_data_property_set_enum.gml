/// @param UIButton
function dc_map_data_property_set_enum(argument0) {

    var button = argument0;
    var base_dialog = button.root.root.root;
    var selection_index = ui_list_selection(button.root.el_list_main);
    var data_index = ui_list_selection(base_dialog.el_list);

    if (selection_index + 1) {
        var data = Stuff.map.active_map.generic_data[data_index];
    
        var list_enum = ds_list_create();
    
        for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
            if (Stuff.all_data[| i].type == DataTypes.ENUM) {
                ds_list_add(list_enum, Stuff.all_data[| i]);
            }
        }
    
        ds_list_sort_name(list_enum);
        var type = list_enum[| selection_index];
        data.value_type_guid = type.GUID;
        ds_list_destroy(list_enum);
    
        base_dialog.el_data_type_guid.text = type.name + "(Select)";
        base_dialog.el_data_type_guid.color = c_black;
    
        dialog_map_data_enable_by_type(base_dialog);
    }

    dialog_destroy();


}
