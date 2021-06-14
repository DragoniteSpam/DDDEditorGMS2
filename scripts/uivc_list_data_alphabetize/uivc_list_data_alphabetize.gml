function uivc_list_data_alphabetize(list) {
    // put the enums at the top
    var list_data = [];
    var list_enums = [];
    for (var i = 0; i < array_length(Game.data); i++) {
        var data = Game.data[i];
        if (data.type == DataTypes.ENUM) {
            array_push(list_enums, data);
        } else {
            array_push(list_data, data);
        }
    }
    
    // Normally you'd just use the list sort funciton on the source lists since they
    // don't modify them, but in this case we want the enums to always go at the top
    var list_enums_sorted = array_sort_name(list_enums);
    var list_data_sorted = array_sort_name(list_data);
    array_resize(Game.data, 0);
    for (var i = 0; i < array_length(list_enums_sorted); i++) {
        array_push(Game.data, list_enums_sorted[i]);
    }
    for (var i = 0; i < array_length(list_data_sorted); i++) {
        array_push(Game.data, list_data_sorted[i]);
    }
    
    var selection = ui_list_selection(list);
    
    if (selection + 1) {
        ui_list_deselect(list);
        ui_list_select(list, array_search(Game.data, list.root.selected_data), true);
    }
}