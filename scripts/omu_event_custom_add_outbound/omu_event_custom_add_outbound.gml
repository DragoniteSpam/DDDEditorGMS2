/// @param UIThing
function omu_event_custom_add_outbound(argument0) {

    var thing = argument0;
    var event = thing.root.event;

    ds_list_add(event.outbound, "Outbound" + string(ds_list_size(event.outbound)));

    thing.root.el_outbound_add.interactive = ds_list_size(event.outbound) < 10;
    thing.root.el_outbound_remove.interactive = true;


}
