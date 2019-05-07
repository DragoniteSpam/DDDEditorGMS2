/// @description  uivc_input_entity_off_y(UIThing);
/// @param UIThing

var list=Camera.selected_entities;

for (var i=0; i<ds_list_size(list); i++){
    var thing=list[| i];
    if (thing.offsettable){        
        if (script_execute(argument0.validation, argument0.value)){
            thing.off_yy=clamp(real(argument0.value), argument0.value_lower, argument0.value_upper);
            thing.modification=Modifications.UPDATE;
            ds_list_add(Camera.changes, thing);
        }
    }
}
