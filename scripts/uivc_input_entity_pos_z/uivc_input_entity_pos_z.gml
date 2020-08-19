/// @param UIInput
function uivc_input_entity_pos_z(argument0) {

    var input = argument0;

    var list = Stuff.map.selected_entities;

    for (var i = 0; i < ds_list_size(list); i++) {
        var thing = list[| i];
        if (thing.translateable) {        
            map_move_thing(thing, thing.xx, thing.yy, real(input.value));
        }
    }


}
