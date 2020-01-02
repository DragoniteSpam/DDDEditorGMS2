/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var file_data = list.entries[| selection];
    list.root.el_compressed.interactive = true;
    list.root.el_types.interactive = true;
    list.root.el_compressed.value = file_data.compressed;
    // pick out data types that go to this data file
    ui_list_deselect(list.root.el_types);
    for (var i = 0; i < array_length_1d(Stuff.game_data_location); i++) {
        if (Stuff.game_data_location[i] == file_data.GUID) {
            ui_list_select(list.root.el_types, i);
        } else if (i == 0 && !guid_get(Stuff.game_data_location[i])) {
            ui_list_select(list.root.el_types, i);
        }
    }
    // the first file in the list is special, and its name is just whatever you give it when you save
    if (selection) {
        list.root.el_name.interactive = true;
        ui_input_set_value(list.root.el_name, file_data.internal_name);
    }
} else {
    list.root.el_name.interactive = false;
    list.root.el_compressed.interactive = false;
    list.root.el_types.interactive = false;
}