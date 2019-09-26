/// @param UIThing

var thing = argument0;
var event = thing.root.event;
var list = thing.root.el_outbound;

var index = ui_list_selection(list);

ds_list_delete(event.outbound, index);
if (index >= ds_list_size(event.outbound)) {
	ui_list_deselect(list);
	ds_map_add(list.selected_entries, --index, true);
}
thing.root.el_outbound_name.value = event.outbound[| index];

thing.root.el_outbound_add.interactive = true;
thing.root.el_outbound_remove.interactive = ds_list_size(event.outbound) > 1;