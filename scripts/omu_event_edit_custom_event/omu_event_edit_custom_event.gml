/// @description void omu_event_edit_custom_event(UIThing);
/// @param UIThing

var selection=ui_list_selection(argument0.root.root.el_list_custom);

if (selection>=0) {
    dialog_create_event_custom(argument0.root);
}
