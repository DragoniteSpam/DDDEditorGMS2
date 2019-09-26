/// @param UIThing

var thing = argument0;
var event = thing.root.event;

if (ds_list_size(event.outbound) > 0) {
	ds_list_delete(event.outbound, index);
}

thing.root.el_outbound_add.interactive = true;
thing.root.el_outbound_remove.interactive = ds_list_size(event.outbound) > 1;