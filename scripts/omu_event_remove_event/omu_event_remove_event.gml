function omu_event_remove_event(button) {
    var index = ui_list_selection(button.root.el_event_list);
    
    if (index + 1 && ds_list_size(Stuff.all_events) > index) {
        if (ds_list_size(Stuff.all_events) == 1) {
            emu_dialog_notice("Can't delete the only event!");
        } else {
            dialog_create_event_delete(Stuff.all_events[| index], button.root);
        }
    }
}