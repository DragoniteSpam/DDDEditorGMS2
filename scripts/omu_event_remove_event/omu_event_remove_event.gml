function omu_event_remove_event(button) {
    var index = ui_list_selection(button.root.el_event_list);
    
    if (index + 1 && ds_list_size(Game.evenst) > index) {
        if (ds_list_size(Game.evenst) == 1) {
            emu_dialog_notice("Can't delete the only event!");
        } else {
            dialog_create_event_delete(Game.evenst[| index], button.root);
        }
    }
}