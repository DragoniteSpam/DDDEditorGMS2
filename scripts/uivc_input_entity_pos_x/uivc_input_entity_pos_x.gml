/// @param UIInput
function uivc_input_entity_pos_x(argument0) {

    var input = argument0;
    var list = Stuff.map.selected_entities;

    for (var i = 0; i < ds_list_size(list); i++) {
        var thing = list[| i];
        if (thing.translateable) {        
            // you could probably do a Modification thing here but since you need
            // to deal with removing and re-adding Things into the grid this is
            // way easier
            Stuff.map.active_map.Move(thing, real(input.value), thing.yy, thing.zz);
        }
    }


}
