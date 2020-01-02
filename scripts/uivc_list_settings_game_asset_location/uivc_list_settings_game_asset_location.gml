/// @param UIList

var list = argument0;
var list_main = list.root.el_list;
var selection_main = ui_list_selection(list_main);

if (selection_main + 1) {
    var file_data = list_main.entries[| selection_main];
    if (ui_list_selection(list) + 1) {
        for (var i = ds_map_find_first(list.selected_entries); i != undefined; i = ds_map_find_next(list.selected_entries, i)) {
            Stuff.game_data_location[i] = file_data.GUID;
        }
    }
}