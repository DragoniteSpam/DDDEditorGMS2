/// @param UIButton

var button = argument0;
var custom = button.root.custom;
var index = ds_list_find_index(Stuff.all_event_custom, custom);

instance_activate_object(custom);
instance_destroy(custom);
ds_list_delete(Stuff.all_event_custom, index);
ui_list_deselect(button.root.root.root.el_list_custom);

/*
if (show_question("Delete " + custom.name + "? If you have any instances of it instantiated, they will also be deleted and event graphs may break.")) {

    // todo make the thing in the warning actually happen
}*/

dc_default(button);