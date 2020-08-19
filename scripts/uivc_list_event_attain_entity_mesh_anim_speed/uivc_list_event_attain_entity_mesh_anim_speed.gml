/// @param UIInput
function uivc_list_event_attain_entity_mesh_anim_speed(argument0) {

    var input = argument0;

    var data = input.root.node.custom_data[| 1];
    data[| 0] = real(input.value);


}
