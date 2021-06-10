/// @param UIThing
function omu_event_remove_custom_event(argument0) {

    var thing = argument0;

    var index = ui_list_selection(thing.root.root.el_list_custom);

    if (index + 1) {
        dialog_create_event_custom_delete(Stuff.Game.events.custom[| index], thing.root);
    }


}
