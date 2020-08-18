/// @param UIButton
function uivc_event_custom_delete(argument0) {

	var button = argument0;
	var custom = button.root.custom;
	var index = ds_list_find_index(Stuff.all_event_custom, custom);

	ds_list_delete(Stuff.all_event_custom, index);
	ui_list_deselect(button.root.root.root.el_list_custom);

	for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
	    var event = Stuff.all_events[| i];
	    for (var j = 0; j < ds_list_size(event.nodes); j++) {
	        if (event.nodes[| j].custom_guid == custom.GUID) {
	            instance_destroy_later(event.nodes[| j]);
	        }
	    }
	}

	instance_activate_object(custom);
	instance_destroy(custom);

	dc_default(button);


}
