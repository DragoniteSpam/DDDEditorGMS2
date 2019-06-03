/// @description void uivc_entity_mob_animating(UIThing);
/// @param UIThing

// this assumes that every selected entity is already an instance of Pawn
var list=Camera.selected_entities;

for (var i=0; i<ds_list_size(list); i++) {
    list[| i].is_animating=argument0.value;
}
