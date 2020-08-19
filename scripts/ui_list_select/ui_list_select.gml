/// @param UIList
/// @param value
/// @param [set-index?]
function ui_list_select() {

    var list = argument[0];
    var value = argument[1];
    var set_index = (argument_count > 2) ? argument[2] : false;

    ds_map_add(list.selected_entries, value, true);

    if (set_index) {
        if (!is_clamped(value, list.index, list.index + list.slots - 1)) {
            // clamp() sorta breaks if the max value is lower than the min value
            list.index = max(0, min(value, ds_list_size(list.entries) - list.slots));
        }
    }


}
