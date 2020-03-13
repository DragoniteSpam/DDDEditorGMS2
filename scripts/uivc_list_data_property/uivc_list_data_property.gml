/// @param UIList

var list = argument0;

var selection = ui_list_selection(list);
dialog_data_type_disable(list.root);

if (selection + 1) {
    var listofthings = list.root.selected_data.properties;
    
    if (listofthings[| selection] != list.root.selected_property) {
        list.root.selected_property = listofthings[| selection];
        
        dialog_data_type_enable_by_type(list.root);
    }
}