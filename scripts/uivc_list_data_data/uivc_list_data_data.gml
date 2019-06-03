/// @description uivc_list_data_data(UIList);
/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    if (Stuff.setting_alphabetize_lists) {
        var listofthings = ds_list_sort_name_sucks(Stuff.all_data);
    } else {
        var listofthings = Stuff.all_data;
    }
    if (listofthings[| selection] != argument0.root.selected_data) {
        argument0.root.selected_data = listofthings[| selection];
        argument0.root.selected_property = noone;
        
        ds_map_clear(argument0.root.el_list_p.selected_entries);
        
        dialog_data_type_disable(argument0.root);
        
        argument0.root.el_data_name.interactive = true;
        argument0.root.el_add_p.interactive = true;
        argument0.root.el_remove_p.interactive = true;
        
        argument0.root.el_data_name.value = argument0.root.selected_data.name;
        
        argument0.root.el_list_p.index = 0;
    }
    if (Stuff.setting_alphabetize_lists) {
        ds_list_destroy(listofthings);
    } else {
        // if it's not alphabetized the list is just all_data[] which you DEFINITELY DO
        // NOT WANT TO DELETE.
    }
}
