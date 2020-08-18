/// @param UICheckbox
function uivc_input_data_size_can_be_zero(argument0) {

	var checkbox = argument0;

	checkbox.root.selected_property.size_can_be_zero = checkbox.value;

	if (!checkbox.root.selected_property.size_can_be_zero) {
	    var instances = checkbox.root.selected_data.instances;
	    var index = ds_list_find_index(checkbox.root.selected_data.properties, checkbox.root.selected_property);
	    var n = 0;
	    for (var i = 0; i < ds_list_size(instances); i++) {
	        var instance = instances[| i];
	        var inst_property = instance.values[| index];
	        if (!ds_list_size(inst_property)) {
	            ds_list_add(inst_property, 0);
	            n++;
	        }
	    }
    
	    if (n > 0) {
	        dialog_create_notice(checkbox.root, string(n) + " instances of " + checkbox.root.selected_data.name + " have default values auto-assigned to their " + checkbox.root.selected_property.name + " property.");
	    }
	}


}
