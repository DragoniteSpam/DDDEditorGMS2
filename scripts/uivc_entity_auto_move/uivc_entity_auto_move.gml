/// @description void uivc_entity_auto_move(UIThing);
/// @param UIThing

// safe
var entity=Camera.selected_entities[| 0];

entity.autonomous_movement=argument0.value;
