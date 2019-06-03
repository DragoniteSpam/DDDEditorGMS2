/// @description void ui_list_clear(UIList);
/// @param UIList
// this clears EVERYTHING in the list - including the entries. most likely,
// you actually want ui_list_deselect.

ds_list_clear(argument0.entries);
ds_list_clear(argument0.entry_colors);
ds_map_clear(argument0.selected_entries);
argument0.index=0;
argument0.last_index=-1;
