/// @param UIThing

var index = ui_list_selection(argument0.root.root.el_list_custom);

if (!index) {
    show_message("select an event first!");
} else {
    var custom = Stuff.all_event_custom[| index];
    
    if (show_question("Delete " + custom.name + "? If you have any instances of it instantiated, they will also be deleted and event graphs may break.")) {
        instance_activate_object(custom);
        instance_destroy(custom);
        ds_list_delete(Stuff.all_event_custom, index);
        // todo make the thing in the warning actually happen
        ui_list_deselect(argument0.root.root.el_list_custom);
    }
}