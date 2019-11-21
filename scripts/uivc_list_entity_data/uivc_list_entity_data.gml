/// @param UIList

var list = argument0;

var selection = ui_list_selection(list);

if (selection + 1) {
    var data = list.entries[| selection];
    ui_input_set_value(list.root.el_name, data.name);
    list.root.el_data_type.value = data.type;
    /*var listofthings = Stuff.all_data;
    if (listofthings[| selection] != list.root.selected_data) {
        list.root.selected_data = listofthings[| selection];
        list.root.selected_property = noone;
        
        ui_list_deselect(list.root.el_list_p);
        
        dialog_data_type_disable(list.root);
        
        list.root.el_data_name.interactive = true;
        list.root.el_add_p.interactive = true;
        list.root.el_remove_p.interactive = true;
        
        ui_input_set_value(list.root.el_data_name, list.root.selected_data.name);
        
        list.root.el_list_p.index = 0;
    }*/
}