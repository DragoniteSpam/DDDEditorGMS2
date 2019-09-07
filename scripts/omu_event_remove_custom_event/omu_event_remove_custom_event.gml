/// @param UIThing

var thing = argument0;

var index = ui_list_selection(thing.root.root.el_list_custom);
ui_list_deselect(thing.root.root.el_list_custom);

if (index) {
    var custom = Stuff.all_event_custom[| index];
    
    if (show_question("Delete " + custom.name + "? If you have any instances of it instantiated, they will also be deleted and event graphs may break.")) {
        instance_activate_object(custom);
        instance_destroy(custom);
        ds_list_delete(Stuff.all_event_custom, index);
        // todo make the thing in the warning actually happen
    }
}