function ui_list_clear(list) {
    // this clears EVERYTHING in the list - including the entries. most likely,
    // you actually want ui_list_deselect.
    ds_list_clear(list.entries);
    ds_list_clear(list.entry_colors);
    ui_list_deselect(list);
    list.index = 0;
    list.last_index = -1;
}