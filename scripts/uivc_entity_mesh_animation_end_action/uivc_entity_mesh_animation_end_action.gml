/// @param UIRadioArray
function uivc_entity_mesh_animation_end_action(argument0) {

    var radio = argument0;

    // this assumes that every selected entity is already an instance of Mesh
    var list = Stuff.map.selected_entities;

    for (var i = 0; i < ds_list_size(list); i++) {
        list[| i].animation_end_action = radio.value;
    }


}
