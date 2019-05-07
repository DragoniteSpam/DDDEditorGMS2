/// @description  uivc_input_entity_pos_y(UIThing);
/// @param UIThing

var list=Camera.selected_entities;

for (var i=0; i<ds_list_size(list); i++){
    var thing=list[| i];
    if (thing.translateable){        
        if (script_execute(argument0.validation, argument0.value)){
            map_move_thing(thing, thing.xx, clamp(real(argument0.value), argument0.value_lower, argument0.value_upper), thing.zz);
        }
    }
}
