/// @param UIThing
function omu_event_add_custom_event(argument0) {

    var thing = argument0;

    var custom = new DataEventNodeCustom("CustomNode" + string(ds_list_size(Game.events.custom)));
    ds_list_add(Game.events.custom, custom);


}