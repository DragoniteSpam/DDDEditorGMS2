/// @param Dialog

var dialog = argument0;
var selection = ui_list_selection(dialog.root.el_list);

if (selection + 1) {
    dialog_create_event_get_event_entrypoint(dialog, Stuff.all_events[| selection]);
} else {
    dialog_destroy();
}