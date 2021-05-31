/// @param UIButton
function dmu_create_event_event_entrypoint_remove(argument0) {

    var button = argument0;
    var root_element = button.root;
    root_element.node.custom_data[root_element.index][@ root_element.multi_index] = NULL;
    dmu_dialog_commit(button);


}
