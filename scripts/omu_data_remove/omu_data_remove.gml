/// @param UIButton
function omu_data_remove(argument0) {

	var button = argument0;

	if (button.root.selected_data) {
	    instance_activate_object(button.root.selected_data);
	    instance_destroy(button.root.selected_data);
	    ds_list_delete(Stuff.all_data, ds_list_find_index(Stuff.all_data, button.root.selected_data));
    
	    ui_list_deselect(button.root.el_list_main);
	    ui_list_deselect(button.root.el_list_p);
	    script_execute(button.root.el_list_main.onvaluechange, button.root.el_list_main);
	    script_execute(button.root.el_list_p.onvaluechange, button.root.el_list_p);
    
	    button.root.selected_data = noone;
	    button.root.selected_property = noone;
	}


}
