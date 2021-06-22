function omu_map_data_data_select(button) {
    var dialog = dialog_create_data_data_select(button);
    dialog.el_confirm.onmouseup = method(dialog.el_confirm, function(button) {
        var base_dialog = button.root.root.root;
        var selection_index = ui_list_selection(button.root.el_list_main);
        var data_index = ui_list_selection(base_dialog.el_list);
    
        if (selection_index + 1) {
            var data = Stuff.map.active_map.generic_data[data_index];
            var list_enum = [];
            for (var i = 0; i < array_length(Game.data); i++) {
                if (Game.data[i].type == DataTypes.DATA) {
                    array_push(list_enum, Game.data[i]);
                }
            }
            
            var type = array_sort_name(list_enum)[| selection_index];
            data.value_type_guid = type.GUID;
            base_dialog.el_data_type_guid.text = type.name + "(Select)";
            base_dialog.el_data_type_guid.color = c_black;
            dialog_map_data_enable_by_type(base_dialog);
        }
    
        dialog_destroy();
    });
}