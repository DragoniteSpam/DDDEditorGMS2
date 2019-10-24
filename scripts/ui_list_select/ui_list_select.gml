/// @param UIList
/// @param value
/// @param [set-index?]

var list = argument[0];
var value = argument[1];
var set_index = (argument_count > 2) ? argument[2] : false;

ds_map_add(list.selected_entries, value, true);

if (set_index) {
    // clamp() sorta breaks if the max value is lower than the min value
    list.index = max(0, min(value, ds_list_size(list.entries) - list.slots));
}