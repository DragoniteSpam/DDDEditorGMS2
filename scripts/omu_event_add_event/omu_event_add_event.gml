/// @param UIThing
function omu_event_add_event(argument0) {

	var thing = argument0;

	ds_list_add(Stuff.all_events, event_create("Event$" + string(ds_list_size(Stuff.all_events))));


}
