/// @param UIThing

var thing = argument0;
var list = thing.root.el_map_list;

not_yet_implemented();

if (!ds_list_empty(list.entries)) {
    var index = ui_list_selection(list);
    Stuff.game_map_starting = list.entries[| index].GUID;
    dialog_create_settings_data_map_list(list);
    ds_map_add(list.selected_entries, index, index);
}