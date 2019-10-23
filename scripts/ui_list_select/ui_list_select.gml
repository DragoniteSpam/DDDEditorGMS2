/// @param UIList
/// @param value
/// @param [set-index?]

var list = argument[0];
var value = argument[1];
var set_index = (argument_count > 2) ? argument[2] : false;

ds_map_add(list.selected_entries, value, true);

if (set_index) {
    list.index = clamp(value, 0, ds_list_size(list.entries) - list.slots);
}