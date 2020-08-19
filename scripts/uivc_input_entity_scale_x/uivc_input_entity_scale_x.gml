/// @param UIInput
function uivc_input_entity_scale_x(argument0) {

    var input = argument0;

    var list = Stuff.map.selected_entities;

    for (var i = 0; i < ds_list_size(list); i++) {
        var thing =list[| i];
        if (thing.scalable) {        
            thing.scale_xx = real(input.value);
            editor_map_mark_changed(thing);
        }
    }


}
