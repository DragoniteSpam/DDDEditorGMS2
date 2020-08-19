/// @description void uivc_entity_auto_move(UIThing);
/// @param UIThing
function uivc_entity_auto_move(argument0) {

    // safe
    var entity=Stuff.map.selected_entities[| 0];

    entity.autonomous_movement=argument0.value;



}
