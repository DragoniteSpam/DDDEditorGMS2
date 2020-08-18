/// @param UIButton
function dmu_dialog_event_set_outbound_null(argument0) {

	var button = argument0;

	var node = button.root.node;
	var index = button.root.index;

	event_connect_node(node, noone, index, true);

	dialog_destroy();


}
