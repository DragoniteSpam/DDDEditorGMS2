/// @description uivc_list_data_editor(UIList);
/// @param UIList

if (ds_list_empty(Stuff.all_data)) {
    momu_data_types(noone);
} else {
    var selection=ui_list_selection(argument0);
    argument0.root.active_type_guid=0;      // assume null until proven otherwise
    
    if (selection>=0) {
        if (Stuff.setting_alphabetize_lists) {
            var listofthings=ds_list_sort_name_sucks(Stuff.all_data);
        } else {
            var listofthings=Stuff.all_data;
        }
        if (listofthings[| selection].GUID!=argument0.root.active_type_guid) {
            argument0.root.active_type_guid=listofthings[| selection].GUID;
        }
        if (Stuff.setting_alphabetize_lists) {
            ds_list_destroy(listofthings);
        } else {
            // if it's not alphabetized the list is just all_data[] which you DEFINITELY DO
            // NOT WANT TO DELETE.
        }
    }
    
    ui_init_game_data_activate();
}
