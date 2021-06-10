/// @param UIThing
function omu_event_rename_event(argument0) {

    var thing = argument0;
    var selection = ui_list_selection(thing.root.el_event_list);

    if (selection + 1) {
        dialog_create_event_rename(Game.events.events[| selection]);
    }


}
