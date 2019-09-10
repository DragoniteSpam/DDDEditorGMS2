/// @param UIList

var list = argument0;

if (ds_list_empty(Stuff.all_data)) {
    momu_data_types(noone);
} else {
    var selection = ui_list_selection(list);
    list.root.active_type_guid = 0;      // assume null until proven otherwise
    
    if (selection >= 0) {
        var listofthings = Stuff.all_data;
        if (listofthings[| selection].GUID != list.root.active_type_guid) {
            list.root.active_type_guid = listofthings[| selection].GUID;
        }
    }
    
    ui_init_game_data_activate();
}