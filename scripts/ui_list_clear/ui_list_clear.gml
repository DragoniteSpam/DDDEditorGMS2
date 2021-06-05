function ui_list_clear(list) {
    // this clears EVERYTHING in the list - including the entries. most likely,
    // you actually want ui_list_deselect.
    if (is_numeric(list.entries)) {
        ds_list_clear(list.entries);
    }
    if (is_numeric(list.entry_colors)) {
        ds_list_clear(list.entry_colors);
    }
    ui_list_deselect(list);
    list.index = 0;
    list.last_index = -1;
}