/// @description  void dmu_data_starting_map(UIThing);
/// @param UIThing

var list=argument0.root.el_map_list;

if (!ds_list_empty(list.entries)){
    var index=ui_list_selection(list);
    Stuff.game_map_starting=list.entries[| index];
    dialog_create_settings_data_map_list(list);
    ds_map_add(list.selected_entries, index, index);
}
