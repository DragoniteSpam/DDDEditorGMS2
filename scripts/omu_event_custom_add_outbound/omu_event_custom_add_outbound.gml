/// @param UIThing
function omu_event_custom_add_outbound(argument0) {

    var thing = argument0;
    var event = thing.root.event;

    array_push(event.outbound, "Outbound" + string(array_length(event.outbound)));

    thing.root.el_outbound_add.interactive = array_length(event.outbound) < 10;
    thing.root.el_outbound_remove.interactive = true;


}
