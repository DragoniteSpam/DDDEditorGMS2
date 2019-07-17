/// @param UIList

var selection = ui_list_selection(argument0);

if (selection >= 0) {
    var listofthings = argument0.root.selected_data.properties;
    
    if (listofthings[| selection] != argument0.root.selected_property) {
        argument0.root.selected_property = listofthings[| selection];
        
        dialog_data_type_disable(argument0.root);
        dialog_data_type_enable_by_type(argument0.root);
    }
}