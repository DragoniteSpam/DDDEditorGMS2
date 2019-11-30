/// @param EntityPawn

var pawn = argument0;

safc_on_entity(pawn);

Stuff.map.ui.element_entity_mesh_animated.interactive = false;

ui_input_set_value(Stuff.map.ui.element_entity_pawn_frame, string(floor(pawn.frame)));
Stuff.map.ui.element_entity_pawn_direction.value = pawn.map_direction;
Stuff.map.ui.element_entity_pawn_animating.value = pawn.is_animating;

Stuff.map.ui.element_entity_pawn_frame.interactive = true;
Stuff.map.ui.element_entity_pawn_direction.interactive = true;
Stuff.map.ui.element_entity_pawn_animating.interactive = true;