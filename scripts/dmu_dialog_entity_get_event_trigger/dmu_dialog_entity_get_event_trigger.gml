/// @param UIThing

var thing = argument0;

var selection_index = ui_list_selection(thing.root.el_list);

if (selection_index >= 0) {
    thing.root.page.trigger = selection_index;
	thing.root.root.el_trigger.value = selection_index;
}

dmu_dialog_commit(thing);