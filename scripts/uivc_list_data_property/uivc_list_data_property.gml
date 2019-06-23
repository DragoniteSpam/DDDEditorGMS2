/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    if (Stuff.setting_alphabetize_lists) {
        var listofthings = ds_list_sort_name_sucks(argument0.root.selected_data.properties);
    } else {
        var listofthings = argument0.root.selected_data.properties;
    }
    if (listofthings[| selection] != argument0.root.selected_property) {
        argument0.root.selected_property = listofthings[| selection];
        
        dialog_data_type_disable(argument0.root);
        dialog_data_type_enable_by_type(argument0.root);
    }
    if (Stuff.setting_alphabetize_lists) {
        ds_list_destroy(listofthings);
    } else {
        // if it's not alphabetized the list is just the generic data property list which you
        // definitely do not want to delete
    }
}