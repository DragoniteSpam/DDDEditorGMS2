function omu_event_custom_enum_select(button) {
    var dialog = dialog_create_data_enum_select(button);
    dialog.el_confirm.onmouseup = method(dialog.el_confirm, function(button) {
        var pselection = ui_list_selection(thing.root.root.root.el_list);
        var property = thing.root.root.root.event.types[pselection];
        var selection = ui_list_selection(thing.root.el_list_main);
        
        if (selection + 1) {
            var list_data = [];
            for (var i = 0; i < array_length(Game.data); i++) {
                if (Game.data[i].type == DataTypes.ENUM) {
                    array_push(list_data, Game.data[i]);
                }
            }
            
            var data = array_sort_name(list_data)[selection];
            property.type_guid = data.GUID;
            thing.root.root.root.event.types[@ pselection] = property;
            thing.root.root.root.el_property_type_guid.text = "Select (" + data.name + ")";
            thing.root.root.root.el_property_type_guid.color = c_black;
            thing.root.root.root.changed = true;
        }
        
        dialog_destroy();
    });
}