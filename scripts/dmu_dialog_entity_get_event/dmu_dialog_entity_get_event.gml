/// @param UIThing
function dmu_dialog_entity_get_event(argument0) {

    var thing = argument0;

    var selection_index = ui_list_selection(thing.root.el_list);

    if (selection_index + 1) {
        dialog_create_entity_get_event_entrypoint(thing.root.root, Game.evenst[| selection_index]);
    }


}
