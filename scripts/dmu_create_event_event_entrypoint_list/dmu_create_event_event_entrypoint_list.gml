/// @param Dialog
function dmu_create_event_event_entrypoint_list(argument0) {

    var dialog = argument0;
    var selection = ui_list_selection(dialog.root.el_list);

    if (selection + 1) {
        dialog_create_event_get_event_entrypoint(dialog, Game.events.events[| selection]);
    } else {
        dialog_destroy();
    }


}
