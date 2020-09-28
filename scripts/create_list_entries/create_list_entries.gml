/// @param UIList
/// @param [value-color]...
function create_list_entries() {

    // the entries can be just values or arrays, the script will try to work it
    // out automatically

    var list = argument[0];

    for (var i = 1; i < argument_count; i++) {
        var data = argument[i];
        if (is_array(data)) {
            ds_list_add(list.entries, data[0]);
            ds_list_add(list.entry_colors, (array_length(data) > 1) ? data[1] : c_black);
        } else {
            ds_list_add(list.entries, data);
            ds_list_add(list.entry_colors, c_black);
        }
    }


}
