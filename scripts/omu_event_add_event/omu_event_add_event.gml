/// @param UIThing
function omu_event_add_event(argument0) {

    var thing = argument0;

    ds_list_add(Game.evenst, event_create("Event$" + string(ds_list_size(Game.evenst))));


}
