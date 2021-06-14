/// @param UIButton
function dc_entity_data_property_set_enum(argument0) {

    var button = argument0;
    var base_dialog = button.root.root.root;
    var selection_index = ui_list_selection(button.root.el_list_main);
    var data_index = ui_list_selection(base_dialog.el_list);

    if (selection_index + 1) {
        var data = base_dialog.entity.generic_data[data_index];
    
        var list_enum = [];
    
        for (var i = 0; i < array_length(Game.data); i++) {
            if (Game.data[i].type == DataTypes.ENUM) {
                array_push(list_enum, Game.data[i]);
            }
        }
    
        array_sort_name(list_enum);
        var type = list_enum[selection_index];
        data.value_type_guid = type.GUID;
    
        base_dialog.el_data_type_guid.text = type.name + "(Select)";
        base_dialog.el_data_type_guid.color = c_black;
    
        dialog_entity_data_enable_by_type(base_dialog);
    }

    dialog_destroy();


}
