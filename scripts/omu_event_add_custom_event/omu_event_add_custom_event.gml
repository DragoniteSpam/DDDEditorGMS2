/// @param UIThing
function omu_event_add_custom_event(argument0) {

    var thing = argument0;

    var custom = new DataEventNodeCustom("CustomNode" + string(array_length(Game.events.custom)));
    array_push(Game.events.custom, custom);


}