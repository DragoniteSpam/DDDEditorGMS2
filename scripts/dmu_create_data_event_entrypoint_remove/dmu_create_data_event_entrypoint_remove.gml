/// @param UIButton
function dmu_create_data_event_entrypoint_remove(argument0) {

    var button = argument0;
    var root_element = button.root.root;

    var instance = root_element.instance;
    instance.values[@ root_element.key][@ 0] = NULL;
    root_element.text = "Select Event";
    dmu_dialog_commit(button);


}
