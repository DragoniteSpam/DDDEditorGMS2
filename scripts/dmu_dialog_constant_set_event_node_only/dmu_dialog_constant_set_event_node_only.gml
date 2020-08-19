/// @param UIButton
function dmu_dialog_constant_set_event_node_only(argument0) {
    // this is for when you select the Entrypoint button directly, instead of finding it
    // through the Event button

    var button = argument0;

    var selection = ui_list_selection(button.root.el_list);
    var event = button.root.event;
    var constant = button.root.constant;
    var entrypoint = button.root.el_list.entries[| selection];

    if (entrypoint) {
        constant.value_guid = entrypoint.GUID;
        var constant_dialog = button.root.root;
        constant_dialog.el_event.text = "Event: " + event.name;
        constant_dialog.el_event_entrypoint.text = "Entrypoint: " + entrypoint.name;
        dialog_destroy();
    }


}
