/// @param UIThing
function uivc_entity_auto_speed(argument0) {

    // safe
    var entity = Stuff.map.selected_entities[| 0];

    entity.autonomous_movement_speed = argument0.value;


}
