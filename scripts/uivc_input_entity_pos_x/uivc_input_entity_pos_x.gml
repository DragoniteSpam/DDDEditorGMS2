/// @description uivc_input_entity_pos_x(UIThing);
/// @param UIThing

var list=Camera.selected_entities;

for (var i=0; i<ds_list_size(list); i++) {
    var thing=list[| i];
    if (thing.translateable) {        
        if (script_execute(argument0.validation, argument0.value)) {
            // you could probably do a Modification thing here but since you need
            // to deal with removing and re-adding Things into the grid this is
            // way easier
            map_move_thing(thing, clamp(real(argument0.value), argument0.value_lower, argument0.value_upper), thing.yy, thing.zz);
        }
    }
}
