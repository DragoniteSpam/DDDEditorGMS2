/// @description void safc_on_pawn(EntityPawn);
/// @param EntityPawn

safc_on_entity(argument0);

Camera.ui.element_entity_mob_frame.value=string(argument0.frame);
Camera.ui.element_entity_mob_direction.value=argument0.map_direction;
Camera.ui.element_entity_mob_animating.value=argument0.is_animating;

Camera.ui.element_entity_mob_frame.interactive=true;
Camera.ui.element_entity_mob_direction.interactive=true;
Camera.ui.element_entity_mob_animating.interactive=true;
