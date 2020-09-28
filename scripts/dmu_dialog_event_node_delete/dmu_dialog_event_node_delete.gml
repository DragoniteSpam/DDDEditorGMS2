/// @param UIThing
function dmu_dialog_event_node_delete(argument0) {

    var thing = argument0;

    instance_destroy_later(thing.root.node);
    script_execute(thing.root.commit, thing.root);


}
