/// @param UIList
/// @param thing0,[color0]
/// @param [...thingn,[colorn]]

// the entries can be just values or arrays, the script will try to work it
// out automatically

for (var i = 1; i < argument_count; i++) {
    var data = argument[i];
    if (is_array(data)) {
        ds_list_add(argument[0].entries, data[0]);
        ds_list_add(argument[0].entry_colors, (array_length_1d(data) > 1) ? data[1] : c_black);
    } else {
        ds_list_add(argument[0].entries, data);
        ds_list_add(argument[0].entry_colors, c_black);
    }
}