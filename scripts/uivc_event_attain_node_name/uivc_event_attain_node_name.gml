/// @param UIInput
function uivc_event_attain_node_name(argument0) {

    var input = argument0;
    event_rename_node(input.root.node.event, input.root.node, input.value + input.root.suffix);


}
