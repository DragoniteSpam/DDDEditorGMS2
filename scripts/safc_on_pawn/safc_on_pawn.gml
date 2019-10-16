/// @param EntityPawn

var pawn = argument0;

safc_on_entity(pawn);

Camera.ui.element_entity_mesh_animated.interactive = false;

Camera.ui.element_entity_pawn_frame.value = string(pawn.frame);
Camera.ui.element_entity_pawn_direction.value = pawn.map_direction;
Camera.ui.element_entity_pawn_animating.value = pawn.is_animating;

Camera.ui.element_entity_pawn_frame.interactive = true;
Camera.ui.element_entity_pawn_direction.interactive = true;
Camera.ui.element_entity_pawn_animating.interactive = true;