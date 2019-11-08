/// @description void uivc_entity_auto_frequency(UIThing);
/// @param UIThing

// safe
var entity=Stuff.map.selected_entities[| 0];

entity.autonomous_movement_frequency=argument0.value;
