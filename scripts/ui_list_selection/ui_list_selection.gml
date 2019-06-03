/// @description int ui_list_selection(UIList);
/// @param UIList

// this is only guaranteed to work if the list only supports single
// selection. if multiple selection is enabled it'll just return a
// random element.

// if nothing is selected it returns noone instead.

if (ds_map_size(argument0.selected_entries)==0) {
    return noone;
}

return ds_map_find_first(argument0.selected_entries);
