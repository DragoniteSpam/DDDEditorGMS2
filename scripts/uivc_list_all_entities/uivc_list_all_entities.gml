function uivc_list_all_entities(list) {
    selection_clear();
    
    var new_mask = 0;
    for (var i = ds_map_find_first(list.selected_entries); i != undefined; i = ds_map_find_next(list.selected_entries, i)) {
        var thing = list.entries[| i];
        new_mask |= thing.etype_flags;
        selection_add(SelectionSingle, thing.xx, thing.yy, thing.zz);
    }
    Settings.selection.mask = new_mask;
    sa_process_selection();
}