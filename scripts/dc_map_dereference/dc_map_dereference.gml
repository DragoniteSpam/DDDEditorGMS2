/// @description  void dc_map_dereference(Dialog);
/// @param Dialog

var list=argument0.root.root.el_map_list;

var index=ui_list_selection(list);
var mapname=list.entries[| index];
if (ds_map_exists(Stuff.all_maps, mapname)){
    ds_map_delete(Stuff.all_maps, mapname);
    dialog_create_settings_data_map_list(list);
    if (ds_list_size(list.entries)>index){
        ds_map_add(list.selected_entries, index, index);
    }
}

dmu_dialog_commit(argument0);
