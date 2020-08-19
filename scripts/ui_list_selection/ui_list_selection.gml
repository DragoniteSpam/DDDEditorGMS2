/// @param UIList
function ui_list_selection(argument0) {
    // this is only guaranteed to work if the list only supports single selection. if multiple
    // selection is enabled it'll just return a random element.

    // if nothing is selected it returns -1 instead.

    var list = argument0;

    if (ds_map_size(list.selected_entries) == 0) {
        return -1;
    }

    return ds_map_find_first(list.selected_entries);


}
