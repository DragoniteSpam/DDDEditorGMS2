/// @param UIRadioArray
function uivc_list_event_attain_entity_mesh_anim_end_action(argument0) {

    var radio = argument0;

    var data = radio.root.root.node.custom_data[| 2];
    data[| 0] = radio.value;


}
