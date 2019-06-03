/// @description void omu_entity_get_event(UIThing);
/// @param UIThing

// not sure if this is standard; argument0 is the button itself, so
// if you want to properly parent the new dialog, it needs to go to
// argument0.root
dialog_create_entity_get_event(argument0.root);
