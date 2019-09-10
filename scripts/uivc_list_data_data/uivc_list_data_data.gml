/// @param UIList

var list = argument0;

var selection = ui_list_selection(list);

if (selection >= 0) {
    var listofthings = Stuff.all_data;
    if (listofthings[| selection] != list.root.selected_data) {
        list.root.selected_data = listofthings[| selection];
        list.root.selected_property = noone;
        
        ds_map_clear(list.root.el_list_p.selected_entries);
        
        dialog_data_type_disable(list.root);
        
        list.root.el_data_name.interactive = true;
        list.root.el_add_p.interactive = true;
        list.root.el_remove_p.interactive = true;
        
        list.root.el_data_name.value = list.root.selected_data.name;
        
        list.root.el_list_p.index = 0;
    }
}